local db = require('dashboard')


db.custom_header = {
	'Fight Bugs                      |     |         ',
	'                                \\_V_//         ',
	'                                \\/=|=\\/         ',
	'                                 [=v=]          ',
	'                               __\\___/_____     ',
	'                              /..[  _____  ]    ',
	'                             /_  [ [  M /] ]    ',
	'                            /../.[ [ M /@] ]    ',
	'                           <-->[_[ [M /@/] ]    ',
	'                          /../ [.[ [ /@/ ] ]    ',
	'     _________________]\\ /__/  [_[ [/@/ C] ]    ',
	'    <_________________>>0---]  [=\\ \\@/ C / /    ',
	'       ___      ___   ]/000o   /__\\ \\ C / /     ',
	'          \\    /              /....\\ \\_/ /      ',
	'       ....\\||/....           [___/=\\___/       ',
	'      .    .  .    .          [...] [...]       ',
	'     .      ..      .         [___/ \\___]       ',
	'     .    0 .. 0    .         <---> <--->       ',
	'  /\\/\\.    .  .    ./\\/\\      [..]   [..]       ',
	' / / / .../|  |\\... \\ \\ \\    _[__]   [__]_      ',
	'/ / /       \\/       \\ \\ \\  [____>   <____]     ',
}

db.custom_center = {
    {
        icon = '\u{2719} ',
        desc = 'New file                    ',
        shortcut = 'NULL',
        action = ':new',
    },
    {
        icon = '\u{1f9ae} ',
        desc = 'Open manual                 ',
        shortcut = 'NULL',
        action = ':help zaldis_config.txt',
    },
    {
        icon = '\u{23FB} ',
        desc = 'Quit                        ',
        shortcut = 'NULL',
        action = ':q',
    },
}

db.custom_footer = {
    'Beautiful is better than ugly'
}
