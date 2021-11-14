package Tags::HTML::Form::Image::Grid;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Error::Pure qw(err);
use List::MoreUtils qw(none);
use Readonly;
use Unicode::UTF8 qw(decode_utf8);

Readonly::Array our @FORM_METHODS => qw(post get);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_image_grid', 'form_link', 'form_method', 'title'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# Form CSS style.
	$self->{'css_image_grid'} = 'image-grid';

	# Form link.
	$self->{'form_link'} = undef;

	# Form method.
	$self->{'form_method'} = 'post';

	# Form title.
	$self->{'title'} = undef;

	# Process params.
	set_params($self, @{$object_params_ar});

	# Check form method.
	if (none { $self->{'form_method'} eq $_ } @FORM_METHODS) {
		err "Parameter 'form_method' has bad value.";
	}

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my ($self, $images_ar) = @_;

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_image_grid'}],

		['b', 'form'],
		['a', 'enctype', 'application/x-www-form-urlencoded'],
	);
	if (defined $self->{'form_link'}) {
		$self->{'tags'}->put(
			['a', 'action', $self->{'form_link'}],
		);
	}
	if (defined $self->{'form_method'}) {
		$self->{'tags'}->put(
			['a', 'method', $self->{'form_method'}],
		);
	}
	$self->{'tags'}->put(
		['b', 'fieldset'],
	);
	if (defined $self->{'title'}) {
		$self->{'tags'}->put(
			['b', 'legend'],
			['d', $self->{'title'}],
			['e', 'legend'],
		);
	}
	$self->{'tags'}->put(
		['b', 'ul'],
	);
	foreach my $image_hr (@{$images_ar}) {
		$self->{'tags'}->put(
			['b', 'li'],

			['b', 'input'],
			['a', 'type', 'checkbox'],
			['a', 'id', 'image_'.$image_hr->{'id'}],
			['e', 'input'],

			['b', 'label'],
			['a', 'for', 'image_'.$image_hr->{'id'}],
			['b', 'img'],
			['a', 'src', $image_hr->{'url'}],
			['e', 'img'],
			['e', 'label'],

			['e', 'li'],
		);
	}
	$self->{'tags'}->put(
		['e', 'ul'],
		['e', 'fieldset'],
		['e', 'form'],
		['e', 'div'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', 'ul'],
		['d', 'list-style-type', 'none'],
		['e'],

		['s', 'li'],
		['d', 'display', 'inline-block'],
		['e'],

		['s', 'input[type="checkbox"][id^="image_"]'],
		['d', 'display', 'none'],
		['e'],

		['s', 'label'],
		['d', 'border', '1px solid #fff'],
		['d', 'padding', '10px'],
		['d', 'display', 'block'],
		['d', 'position', 'relative'],
		['d', 'margin', '10px'],
		['d', 'cursor', 'pointer'],
		['e'],

		['s', 'label:before'],
		['d', 'baclground-color', 'white'],
		['d', 'color', 'white'],
		['d', 'content', '" "'],
		['d', 'display', 'block'],
		['d', 'border-radius', '50%'],
		['d', 'border', '1px solid grey'],
		['d', 'position', 'absolute'],
		['d', 'top', '-5px'],
		['d', 'left', '-5px'],
		['d', 'width', '25px'],
		['d', 'height', '25px'],
		['d', 'text-align', 'center'],
		['d', 'line-height', '28px'],
		['d', 'transition-duration', '0.4s'],
		['d', 'transform', 'scale(0)'],
		['e'],

		['s', 'label img'],
		['d', 'height', '100px'],
		['d', 'width', '100px'],
		['d', 'transition-duration', '0.2s'],
		['d', 'transform-origin', '50% 50%'],
		['e'],

		['s', ':checked + label'],
		['d', 'border-color', '#ddd'],
		['e'],

		['s', ':checked + label:before'],
		['d', 'content', '"'.decode_utf8('✓').'"'],
		['d', 'background-color', 'grey'],
		['d', 'transform', 'scale(1)'],
		['e'],

		['s', ':checked + label img'],
		['d', 'transform', 'scale(0.9)'],
		['d', 'box-shadow', '0 0 5px #333'],
		['d', 'z-index', '-1'],
		['e'],
	);

	return;
}

1;

__END__

