"use strict";

module.exports = (hexo) => {
    const isZh = hexo.theme.i18n.languages[0].search(/zh-CN/i) !== -1;
    if (isZh) {
        hexo.log.info(`
ggcctcgtaagccgcctttgagaattcagctcgcgcaacattttatactctccaccgtcccaaggatatcggacccgctacggcgattacctcggtgttatgctaggtccgaacagaactccgt
gtgccggttgcacctcaatcgcctgctataatcttcccgaacgaagaaaggtccattcactgcttcggaatggtcttctgtatctcctcaacgcgtctctcgactcctttgacttgtaaagccc
gccaatagtacatcgcgttacgttcaggctgaccttaacttaaagataatcagactaagttaaacatgccctttaccccaaggagacccagacaccggacggcaatctctgcgaggaatgaatg
ctgac:'######::'########:'########::'######::'##::::'##:'##:::t##::::'###::::'##:::'##::::'###::::'##:::g##::'######:::aggat
tagcg'##...t##:c##.....::...g##..::'##...t##:a##::::g##:a###::g##:::'##g##:::.c##:'##::::'##c##:::t###::g##:'##...t##::cctag
ggtata##:::..::c##::::::::::g##::::t##:::..::c##::::a##:t####:g##::'##:.c##:::.g####::::'##:.g##::c####:c##:a##:::..:::agtcc
gagaa.a######::t######::::::g##::::.t######::t##::::a##:a##a##g##:'##:::.c##:::.g##::::'##:::.c##:c##t##a##:t##::'####:cgaac
agtaa:.....g##:a##...:::::::t##:::::.....c##:t##::::a##:c##.a####:c#########::::a##::::c#########:t##.c####:a##:::t##::aacgt
atctg'##:::a##:a##::::::::::a##::::'##:::c##:g##::::a##:t##:.t###:t##....a##::::t##::::t##....c##:t##:.g###:g##:::t##::ccgac
gtcaa.g######::t########::::t##::::.a######::.c#######::c##::.g##:g##::::t##::::t##::::a##::::t##:g##::.a##:.c######:::cttag
aactg:......:::........:::::..::::::......::::.......:::..::::..::..:::::..:::::..:::::..:::::..::..::::..:::......::::agtgt
gcgatcacttttgcggacagaagcgcgcgagccctggccacagttgctttacacgagatgaccacgccctgagcgtggccgattcgccctactaaaacgccggagacggaagtcgtccaggttg
`);
    } else {
        hexo.log.info(`
ggcctcgtaagccgcctttgagaattcagctcgcgcaacattttatactctccaccgtcccaaggatatcggacccgctacggcgattacctcggtgttatgctaggtccgaacagaactccgt
gtgccggttgcacctcaatcgcctgctataatcttcccgaacgaagaaaggtccattcactgcttcggaatggtcttctgtatctcctcaacgcgtctctcgactcctttgacttgtaaagccc
gccaatagtacatcgcgttacgttcaggctgaccttaacttaaagataatcagactaagttaaacatgccctttaccccaaggagacccagacaccggacggcaatctctgcgaggaatgaatg
ctgac:'######::'########:'########::'######::'##::::'##:'##:::t##::::'###::::'##:::'##::::'###::::'##:::g##::'######:::aggat
tagcg'##...t##:c##.....::...g##..::'##...t##:a##::::g##:a###::g##:::'##g##:::.c##:'##::::'##c##:::t###::g##:'##...t##::cctag
ggtata##:::..::c##::::::::::g##::::t##:::..::c##::::a##:t####:g##::'##:.c##:::.g####::::'##:.g##::c####:c##:a##:::..:::agtcc
gagaa.a######::t######::::::g##::::.t######::t##::::a##:a##a##g##:'##:::.c##:::.g##::::'##:::.c##:c##t##a##:t##::'####:cgaac
agtaa:.....g##:a##...:::::::t##:::::.....c##:t##::::a##:c##.a####:c#########::::a##::::c#########:t##.c####:a##:::t##::aacgt
atctg'##:::a##:a##::::::::::a##::::'##:::c##:g##::::a##:t##:.t###:t##....a##::::t##::::t##....c##:t##:.g###:g##:::t##::ccgac
gtcaa.g######::t########::::t##::::.a######::.c#######::c##::.g##:g##::::t##::::t##::::a##::::t##:g##::.a##:.c######:::cttag
aactg:......:::........:::::..::::::......::::.......:::..::::..::..:::::..:::::..:::::..:::::..::..::::..:::......::::agtgt
gcgatcacttttgcggacagaagcgcgcgagccctggccacagttgctttacacgagatgaccacgccctgagcgtggccgattcgccctactaaaacgccggagacggaagtcgtccaggttg
`);
    }
};
