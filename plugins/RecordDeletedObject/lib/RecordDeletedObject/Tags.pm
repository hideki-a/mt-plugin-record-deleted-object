package RecordDeletedObject::Tags;
use strict;

sub _hdlr_deleted_objects {
    my ($ctx, $args, $cond) = @_;
    my $res     = '';
    my $tok     = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    my $blog = $ctx->stash('blog') || return;
    my $terms;
    my $load_args;

    $terms->{'blog_id'} = $blog->id;
    $terms->{'class'} = $args->{'class'} || return;
    $load_args->{'sort'} = $args->{'sort_by'} || 'created_on';
    $load_args->{'direction'} = $args->{'sort_order'} || 'descend';

    if (my $limit = $args->{'limit'}) {
        $load_args->{'limit'} = $limit;
    }

    my @objects = MT->model('deletedobject')->load($terms, $load_args);
    my $i = 0;
    local $ctx->{__stash}{deletedobjects}
        = ( @objects && defined $objects[0] ) ? \@objects : undef;
    my $vars = $ctx->{__stash}{vars} ||= {};

    for my $o (@objects) {
        local $vars->{__first__}    = !$i;
        local $vars->{__last__}     = !defined $objects[ $i + 1 ];
        local $vars->{__odd__}      = ( $i % 2 ) == 0;            # 0-based $i
        local $vars->{__even__}     = ( $i % 2 ) == 1;
        local $vars->{__counter__}  = $i + 1;
        local $ctx->{__stash}{blog_id}       = $o->blog_id;
        local $ctx->{__stash}{deletedobject} = $o;
        my $out = $builder->build(
            $ctx, $tok, { %$cond }
        );
        return $ctx->error( $builder->errstr ) unless defined $out;
        $res .= $out;
        $i++;
    }

    $res;
}

sub _hdlr_deleted_date {
    my ( $ctx, $args ) = @_;
    my $o = $ctx->stash('deletedobject')
        or return $ctx->_no_deletedobject_error();

    $args->{ts} = $o->created_on;
    return $ctx->build_date($args);
}

1;