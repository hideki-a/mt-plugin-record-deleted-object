package RecordDeletedObject::DeletedObject;
use strict;

use base qw( MT::Object );
__PACKAGE__->install_properties( {
    column_defs => {
        'blog_id' => {
            'label' => 'BlogID',
            'type' => 'integer'
        },
        'class' => {
            'label' => 'Class',
            'size' => 64,
            'type' => 'string'
        },
        'deleted_object_id' => {
            'label' => 'DeletedObjectID',
            'type' => 'integer'
        },
        'id' => 'integer not null auto_increment',
    },
    indexes => {
        'blog_id' => 1,
        'class' => 1,
    },
    datasource => 'deletedobject',
    primary_key => 'id',
    class_type  => 'deletedobject',
    audit => 1,
} );

1;