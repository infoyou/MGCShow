/* PCAS (Province City Area Selector 省、市、地区联动选择JS封装类) Ver 2.02 完整版 *\
省市联动
new PCAS("Province","City")
new PCAS("Province","City","吉林省")
new PCAS("Province","City","吉林省","吉林市")
省市地区联动
new PCAS("Province","City","Area")
new PCAS("Province","City","Area","吉林省")
new PCAS("Province","City","Area","吉林省","松原市")
new PCAS("Province","City","Area","吉林省","松原市","宁江区")
省、市、地区对象取得的值均为实际值。
注：省、市、地区提示信息选项的值为""(空字符串)


 北京市$市辖区,东城区,西城区,朝阳区,丰台区,石景山区,海淀区,门头沟区,房山区,通州区,顺义区,昌平区,大兴区,怀柔区,平谷区|市辖县,密云县,延庆县#天津市$市辖区,和平区,河东区,河西区,南开区,河北区,红桥区,东丽区,西青区,津南区,北辰区,武清区,宝坻区,滨海新区|市辖县,宁河县,静海县,蓟县#

 # 完整分割
 $ 省份名
 | 区县
*/


SPT="--省份--";
SCT="--城市--";
SAT="--经销商--";
ShowT=1;		//提示文字 0:不显示 1:显示
//PCAD=""; //外部预设数据源
if (ShowT)PCAD = SPT + "$" + SCT + "," + SAT + "#" + PCAD;
PCAArea = [];
PCAP = [];
PCAC = [];
PCAA = [];
PCAN = PCAD.split("#");
for (i = 0; i < PCAN.length; i++) {
    PCAA[i] = [];
    TArea = PCAN[i].split("$")[1].split("|");
    for (j = 0; j < TArea.length; j++) {
        PCAA[i][j] = TArea[j].split(",");
        if (PCAA[i][j].length == 1)PCAA[i][j][1] = SAT;
        TArea[j] = TArea[j].split(",")[0]
    }
    PCAArea[i] = PCAN[i].split("$")[0] + "," + TArea.join(",");
    PCAP[i] = PCAArea[i].split(",")[0];
    PCAC[i] = PCAArea[i].split(',')
}
function PCAS() {
    this.SelP = document.getElementById(arguments[0]);
    this.SelC = document.getElementById(arguments[1]);
    this.SelA = document.getElementById(arguments[2]);
    this.DefP = this.SelA ? arguments[3] : arguments[2];
    this.DefC = this.SelA ? arguments[4] : arguments[3];
    this.DefA = this.SelA ? arguments[5] : arguments[4];
    this.SelP.PCA = this;
    this.SelC.PCA = this;
    this.SelA.PCA = this;
    //this.SetALabel.PCA = this;
    this.SelP.onchange = function () {
        PCAS.SetC(this.PCA)
    };
    if (this.SelA){
    	this.SelC.onchange = function () {
    		
            PCAS.SetA(this.PCA)
        };
//        this.SelA.onchange = function () {
//        	
//            PCAS.SetALabel(this.PCA)
//        };
    }
    
    PCAS.SetP(this)
};
PCAS.SetP = function (PCA) {
    for (i = 0; i < PCAP.length; i++) {
        PCAPT = PCAPV = PCAP[i];
        if (PCAPT == SPT)PCAPV = "";
        PCA.SelP.options.add(new Option(PCAPT, PCAPV));
        if (PCA.DefP == PCAPV)PCA.SelP[i].selected = true
    }
    PCAS.SetC(PCA)
};
PCAS.SetC = function (PCA) {
	//显示用的span默认用name+"_label"
	//var PLabel = PCA.SelP.id+"_label";
	//var label = PCA.SelP.value==""?SPT:PCA.SelP.value;
//	document.getElementById(PLabel).innerHTML=label;
	
    PI = PCA.SelP.selectedIndex;
    PCA.SelC.length = 0;
    for (i = 1; i < PCAC[PI].length; i++) {
        PCACT = PCACV = PCAC[PI][i];
        if (PCACT == SCT)PCACV = "";
        PCA.SelC.options.add(new Option(PCACT, PCACV));
        if (PCA.DefC == PCACV)PCA.SelC[i - 1].selected = true
    }
    if (PCA.SelA)PCAS.SetA(PCA)
};
PCAS.SetA = function (PCA) {
	
	//显示用的span默认用name+"_label"
	//var CLabel = PCA.SelC.id+"_label";
	//var label = PCA.SelC.value==""?SCT:PCA.SelC.value;
//	document.getElementById(CLabel).innerHTML=label;
	
    PI = PCA.SelP.selectedIndex;
    CI = PCA.SelC.selectedIndex;
    PCA.SelA.length = 0;
    for (i = 1; i < PCAA[PI][CI].length; i++) {
        PCAAT = PCAAV = PCAA[PI][CI][i];
        if (PCAAT == SAT)PCAAV = "";
        PCA.SelA.options.add(new Option(PCAAT, PCAAV));
        if (PCA.DefA == PCAAV)PCA.SelA[i - 1].selected = true
    }
    //PCAS.SetALabel(PCA);
};

PCAS.SetALabel = function (PCA) {
	
	//显示用的span默认用name+"_label"
	var ALabel = PCA.SelA.id+"_label";
	var label = PCA.SelA.value==""?SAT:PCA.SelA.value;
//	document.getElementById(ALabel).innerHTML=label;
}