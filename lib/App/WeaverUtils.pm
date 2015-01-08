package App::WeaverUtils;

our $DATE = '2014-12-14'; # DATE
our $VERSION = '0.01'; # VERSION

use 5.010001;
use strict;
use warnings;

our $_complete_stuff = sub {
    require Complete::Module;
    my $which = shift;
    my %args = @_;

    my $word = $args{word} // '';

    # convenience: allow Foo/Bar.{pm,pod,pmc}
    $word =~ s/\.(pm|pmc|pod)\z//;

    # compromise, if word doesn't contain :: we use the safer separator /, but
    # if already contains '::' we use '::' (but this means in bash user needs to
    # use quote (' or ") to make completion behave as expected since : is a word
    # break character in bash/readline.
    my $sep = $word =~ /::/ ? '::' : '/';
    $word =~ s/\W+/::/g;
    my $ns_prefix    = 'Pod::Weaver::'.
        ($which eq 'bundle' ? 'PluginBundle' :
             $which eq 'plugin' ? 'Plugin' :
                 $which eq 'role' ? 'Role' :
                     $which eq 'section' ? 'Section' : ''
                 ).'::';

    {
        words => Complete::Module::complete_module(
            word      => $word,
            ns_prefix => $ns_prefix,
            find_pmc  => 0,
            find_pod  => 0,
            separator => $sep,
            ci        => 1, # convenience
        ),
        path_sep => $sep,
    };
};

our $_complete_bundle = sub {
    $_complete_stuff->('bundle', @_);
};

our $_complete_plugin = sub {
    $_complete_stuff->('plugin', @_);
};

our $_complete_role = sub {
    $_complete_stuff->('role', @_);
};

our $_complete_section = sub {
    $_complete_stuff->('section', @_);
};

1;
# ABSTRACT: Collection of CLI utilities for Pod::Weaver

__END__

=pod

=encoding UTF-8

=head1 NAME

App::WeaverUtils - Collection of CLI utilities for Pod::Weaver

=head1 VERSION

This document describes version 0.01 of App::WeaverUtils (from Perl distribution App-WeaverUtils), released on 2014-12-14.

=head1 DESCRIPTION

This distribution provides several command-line utilities related to
L<Pod::Weaver>.

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/App-WeaverUtils>.

=head1 SOURCE

Source repository is at L<https://github.com/perlancar/perl-App-WeaverUtils>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=App-WeaverUtils>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
