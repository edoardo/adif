#!/usr/bin/perl
#
# generator.pl
# dynamic generation of website pages using templates
#

use strict;

use HTML::Template;

use lib 'lib';
#use feed;

# Defaults
my $cLanguage = 'it';
my $cTmplPath = 'tmpl/'.$cLanguage;
my $cHtmlPath = 'html/'.$cLanguage;

# Website structure
my @aWebsite = (
    { page => 'home', title => 'Associazione Docenti Italiani di Filosofia'  },
    { page => 'consiglio_nazionale', title => 'Consiglio nazionale' },
    { page => 'rivista_per_la_filosofia', title => 'Rivista "Per la filosofia - filosofia e insegnamento"' },
    { page => 'convegni', title => 'Convegni' },
    { page => 'convegni_attivita_locali', title => 'Convegni e attivit&agrave; locali' },
    { page => 'convegno_2003', title => 'XIX Convegno Nazionale di Filosofia, settembre 2003, Cividale del Friuli' },
    { page => 'convegno_2005', title => 'XX Convegno Nazionale di Filosofia, ottobre 2005, Pescara' },
    { page => 'convegno_2007', title => 'XXI Convegno Nazionale di Filosofia, settembre 2007, Cividale del Friuli' },
    { page => 'giornate_kantiane', title => 'Giornate Kantiane' },
    { page => 'contatti', title => 'Contatti' },
    { page => 'info', title => 'Informazioni' },
    { page => 'statuto', title => 'Statuto' },
    { page => 'rivista_per_la_filosofia/regolamento', title => 'Rivista "Per la filosofia - filosofia e insegnamento" - Regolamento' },
    { page => 'rivista_per_la_filosofia/comitato_scientifico', title => 'Rivista "Per la filosofia - filosofia e insegnamento" - Comitato scientifico' },
    { page => 'rivista_per_la_filosofia/comitato_di_redazione', title => 'Rivista "Per la filosofia - filosofia e insegnamento" - Comitato di redazione' },
    { page => 'rivista_per_la_filosofia/segreteria_di_redazione', title => 'Rivista "Per la filosofia - filosofia e insegnamento" - Segreteria di redazione' },
    { page => 'rivista_per_la_filosofia/fascicoli_monografici', title => 'Rivista "Per la filosofia - filosofia e insegnamento" - Fascicoli monografici' },
    { page => 'rivista_per_la_filosofia/cv/luca_valera', title => 'Rivista "Per la filosofia - filosofia e insegnamento" - CV - Luca Valera' },
    { page => 'rivista_per_la_filosofia/cv/vittorio_possenti', title => 'Rivista "Per la filosofia - filosofia e insegnamento" - CV - Vittorio Possenti' },
    { page => 'rivista_per_la_filosofia/cv/bernhard_koerner', title => 'Rivista "Per la filosofia - filosofia e insegnamento" - CV - Bernhard Koerner' },
    { page => 'rivista_per_la_filosofia/cv/dario_sacchi', title => 'Rivista "Per la filosofia - filosofia e insegnamento" - CV - Dario Sacchi' },
    { page => 'rivista_per_la_filosofia/cv/piero_viotto', title => 'Rivista "Per la filosofia - filosofia e insegnamento" - CV - Piero Viotto' },
    { page => 'rivista_per_la_filosofia/cv/vasile_musca', title => 'Rivista "Per la filosofia - filosofia e insegnamento" - CV - Vasile Musca' },
    { page => 'rivista_per_la_filosofia/cv/ovidiu_horea_pop', title => 'Rivista "Per la filosofia - filosofia e insegnamento" - CV - Ovidiu Horea Pop' },
    { page => 'rivista_per_la_filosofia/cv/marco_grusovin', title => 'Rivista "Per la filosofia - filosofia e insegnamento" - CV - Marco Grusovin' },
    { page => 'rivista_per_la_filosofia/cv/francesco_russo', title => 'Rivista "Per la filosofia - filosofia e insegnamento" - CV - Francesco Russo' },
    { page => 'rivista_per_la_filosofia/cv/giorgia_salatiello', title => 'Rivista "Per la filosofia - filosofia e insegnamento" - CV - Giorgia Salatiello' },
    { page => 'rivista_per_la_filosofia/cv/maria_teresa_russo', title => 'Rivista "Per la filosofia - filosofia e insegnamento" - CV - Maria Teresa Russo' },
);

# Get next event (show in all pages)
#my $rItems = feed::getItems( feed::parse( 'rss/harmonia.rss' ) );
#my $cNextEvent = sprintf( '<a href="%s"><b><i>%s</i></b> - %s</a>', $rItems->[0]->{'link'}, substr( $rItems->[0]->{'title'}, 0, 10 ), substr( $rItems->[0]->{'title'}, 13 ) );

# Cicle structure and generate pages from templates
foreach my $rPage ( @aWebsite )
{
    my $cTemplate = $rPage->{'template'} || 'base';
    $cTemplate .= '.tmpl';

    my $oTmpl = HTML::Template->new( filename => $cTemplate, path => [ $cTmplPath ], debug => 1 );#, search_path_on_include => 0 );

    if( open( HTML, "> $cHtmlPath/$rPage->{'page'}.html" ) )
    {
        my @aLocaltime = localtime();

        $oTmpl->param( title => $rPage->{'title'},
#                       next_event => $cNextEvent,
                       content => getContent( $rPage->{'page'} ),
                       year => $aLocaltime[5] + 1900,
        );

        print HTML $oTmpl->output();
        close HTML;
    }
    else
    {
        print "Troubles!";
    }
}

sub getContent
{
    my $cPage = shift;

    my $cContent;

    if( open CONTENT, "$cTmplPath/$cPage.tmpl" )
    {
        $cContent = join( '', <CONTENT> );

        close CONTENT;
    }

    return $cContent;
}
