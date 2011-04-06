``visdo``
=========

Provides the `VisDo` command.

Prefixing any Ex command with `VisDo`
will cause that command to be executed
on the contents of the current visual selection only,
as though it were the entire contents of the buffer.

This makes no difference for linewise visual selections,
but is quite useful for character- and block-wise visual selections.

Examples
--------

-   Basic character-wise usage:

    Initial buffer state::

        Blah blah blee blee blah blah
        blah blah blah blee blah

    In normal mode::

        gg^wwvwwwww

    And then... ::

        :VisDo %s/blah/malkovich/g

    End buffer state::

        Blah blah blee blee malkovich malkovich
        malkovich blah blah blee blah

-   Block-wise usage:

    Initial buffer state::

        IMPORTANT THINGYS    HOW MANY   COMMENT
        Fred                 14         He's really nice.
        Gloxowidgets         2          Too expensive!
        Highlanders          1          There can be only one!

    Previously, on the command line::

        :let multiplier = 42

    In normal mode::

        gg^jW<C-V>jll

    And then... ::

        :VisDo g/./call setline('.', getline('.') * multiplier)

    End buffer state::

        IMPORTANT THINGYS    HOW MANY   COMMENT
        Fred                 588        He's really nice.
        Gloxowidgets         84         Too expensive!
        Highlanders          1          There can be only one!

Gory details
------------

VisDo is implemented by

-   copying the contents of the visual area into a separate buffer
-   executing your command
-   replacing the original buffer's visual selection
    with the resulting buffer contents
-   deleting the temporary buffer (with ``bdel``).

There may be (certainly are) some leaky abstractions here,
but it seems to work pretty well with most use cases.

One thing to note is that although the exec call is made within a function,
the variable context -- i.e. g: for global invocations and l: for local --
is loaded into the local function context before execution.
This is how `multiplier` is used in our second example above.

Changes are **not**, however, copied back.

So if the command that you pass to exec
``let``-s or otherwise changes the value(s) of any local variable(s),
those changes will not be propagated back to wherever you invoked VisDo.

Another thing to keep in mind is that you can use the ``%`` range
to select all of the text you are working on.

See again the block-wise example for an, err, example of this.

Caveats
-------

Some potential sources of abstraction leakage:

-   Buffer-local variables are not copied over into the temp buffer.
-   As mentioned above, any changes made to the execution context
    are effectively lost.
    If you assign to a local variable,
    its value will not be propagated back to the calling context.
