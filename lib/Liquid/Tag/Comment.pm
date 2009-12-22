{

    package Liquid::Tag::Comment;
    use strict;
    use warnings;
    our $VERSION = 0.001;
    use lib '../../../lib';
    use Liquid::Error;
    BEGIN { our @ISA = qw[Liquid::Tag]; }
    Liquid->register_tag('comment', __PACKAGE__) if $Liquid::VERSION;

    sub new {
        my ($class, $args, $tokens) = @_;
        raise Liquid::ContextError {message => 'Missing parent argument',
                                    fatal   => 1
            }
            if !defined $args->{'parent'};
        if ($args->{'attrs'}) {
            raise Liquid::SyntaxError {
                       message => 'Bad argument list in ' . $args->{'markup'},
                       fatal   => 1
            };
        }
        my $self = bless {name     => '#-' . $1,
                          nodelist => [],
                          tag_name => $args->{'tag'},
                          end_tag  => 'end' . $args->{'tag'},
                          parent   => $args->{'parent'},
                          markup   => $args->{'markup'}
        }, $class;
        $self->parse({}, $tokens);
        return $self;
    }
    sub render { }
}
1;

=pod

=head1 NAME

Liquid::Tag::Comment - General Purpose Content Eater

=head1 Synopsis

    {% for article in articles %}
        <div class='post' id='{{ article.id }}'>
            <p class='title'>{{ article.title | capitalize }}</p>
            {% comment %}
                Unless we're viewing a single article, we will truncate
                article.body at 50 words and insert a 'Read more' link.
            {% endcomment %}
            ...
        </div>
    {% endfor %}

=head1 Description

C<comment> is the simplest tag. Child nodes are not rendered so it effectivly
swallows content.

    I love you{% comment %} and your sister {% endcomment %}.

Code inside a C<comment> tag is not executed during rendering. So, this...

    {% assign str = 'Initial value' %}
    {% comment %}
        {% assign str = 'Different value' %}
    {% endcomment %}
    {{ str }}

...would print C<Initial value>.

=head1 See Also

Liquid for Designers: http://wiki.github.com/tobi/liquid/liquid-for-designers

L<Liquid|Liquid/"Create your own filters">'s docs on custom filter creation

=head1 Author

Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

The original Liquid template system was developed by jadedPixel
(http://jadedpixel.com/) and Tobias Lütke (http://blog.leetsoft.com/).

=head1 License and Legal

Copyright (C) 2009 by Sanko Robinson E<lt>sanko@cpan.orgE<gt>

This program is free software; you can redistribute it and/or modify it under
the terms of The Artistic License 2.0.  See the F<LICENSE> file included with
this distribution or http://www.perlfoundation.org/artistic_license_2_0.  For
clarification, see http://www.perlfoundation.org/artistic_2_0_notes.

When separated from the distribution, all original POD documentation is
covered by the Creative Commons Attribution-Share Alike 3.0 License.  See
http://creativecommons.org/licenses/by-sa/3.0/us/legalcode.  For
clarification, see http://creativecommons.org/licenses/by-sa/3.0/us/.

=cut