package RecordDeletedObject::EndPoint::DeletedObject;
use strict;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub get_deleted_entries {
    my ($app, $endpoint) = @_;
    my ($blog) = context_objects(@_) or return;
    my $terms;
    my @ret;

    $terms->{'blog_id'} = $blog->id;
    $terms->{'class'} = 'entry';

    if (my $dateFrom = $app->param('dateFrom')) {
        if ($dateFrom =~ m/\-/) {
            $dateFrom =~ s/\-//g;
        }
        $terms->{'created_on'} = {'>=' => $dateFrom . '000000'};
    }

    my @entries = MT->model('deletedobject')->load($terms);
    foreach my $entry (@entries) {
        my $id = $entry->deleted_object_id;
        push(@ret, $id);
    }

    my $length = @ret;

    return {
        totalResults => $length,
        ids => \@ret
    };
}

1;
