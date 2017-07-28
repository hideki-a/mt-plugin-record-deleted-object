package RecordDeletedObject::Callbacks;

use strict;
use RecordDeletedObject::DeletedObject;

sub post_delete_entry {
    my ($cb, $app, $obj) = @_;

    my $deletedObject = RecordDeletedObject::DeletedObject->new;
    $deletedObject->blog_id($obj->blog_id);
    $deletedObject->class('entry');
    $deletedObject->deleted_object_id($obj->id);

    my @ts = MT::Util::offset_time_list(time, $obj->blog_id);
    my $ts = sprintf "%04d%02d%02d%02d%02d%02d", $ts[5] + 1900, $ts[4] + 1,
        @ts[ 3, 2, 1, 0 ];
    $deletedObject->created_on($ts);
    $deletedObject->modified_on($ts);

    $deletedObject->save
        or die $deletedObject->errstr;

    return 1;
}

1;
