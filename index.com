<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>بوابة الطالب</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Markazi+Text:wght@500;700&family=Noto+Sans+Arabic:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root{
    --paper:#F7F2E7; --card:#EFE7D3; --ink:#26364A; --ink-soft:#4B5A6E;
    --pen:#A63B2E; --pen-soft:#C77361; --line:#D9CFB6; --muted:#7A7263;
    --sea:#2E6E8E; --sea-light:#DCEEF2; --sand:#E8D9B5; --ok:#3D6B4F; --gold:#B8873A;
  }
  *{box-sizing:border-box;}
  body{margin:0; background:var(--paper); color:var(--ink); font-family:'Noto Sans Arabic', sans-serif; line-height:1.8;}
  .sheet{max-width:660px; margin:0 auto; padding:2rem 1.25rem 3rem;}
  .view{display:none;} .view.active{display:block;}
  h1{font-family:'Markazi Text', serif; font-weight:700; font-size:1.9rem; text-align:center; margin:0 0 1.5rem;}
  h2{font-family:'Markazi Text', serif; font-weight:700; font-size:1.3rem; color:var(--pen); margin:0 0 0.7rem;}

  /* ---- Login ---- */
  #view-login{display:flex; flex-direction:column; align-items:center; justify-content:center; min-height:80vh;}
  .login-card{background:var(--card); border-radius:14px; padding:2.5rem 1.75rem; text-align:center; width:100%; max-width:380px;}
  .login-card p{color:var(--muted); font-size:0.95rem; margin:0 0 1.5rem;}
  #student-name-input{width:100%; padding:0.7rem 0.9rem; font-size:1.05rem; border:1px solid var(--line); border-radius:8px; text-align:center; background:var(--paper); color:var(--ink); font-family:'Noto Sans Arabic', sans-serif;}
  #student-name-input:focus{outline:none; border-color:var(--ink);}
  .login-error{color:var(--pen); font-size:0.85rem; min-height:1.2rem; margin:0.5rem 0 0;}
  .primary-btn{width:100%; margin-top:1rem; padding:0.8rem; font-size:1.05rem; font-family:'Noto Sans Arabic', sans-serif; font-weight:600; border:none; border-radius:8px; background:var(--ink); color:var(--paper); cursor:pointer;}
  .primary-btn:hover{background:var(--ink-soft);}

  /* ---- Unit ---- */
  .greeting{text-align:center; color:var(--muted); font-size:1rem; margin:-1rem 0 1.75rem;}
  .lesson-list{display:flex; flex-direction:column; gap:0.9rem;}
  .lesson-card{background:var(--card); border-radius:10px; padding:1.1rem 1.3rem; display:flex; justify-content:space-between; align-items:center; cursor:pointer; border:none; width:100%; text-align:right; font-family:'Noto Sans Arabic', sans-serif; font-size:1.02rem; color:var(--ink);}
  .lesson-card:hover{background:var(--sand);}
  .lesson-card .arrow{color:var(--pen); font-size:1.2rem;}

  /* ---- Lesson shell ---- */
  .back-btn{background:none; border:none; color:var(--ink-soft); font-family:'Noto Sans Arabic', sans-serif; font-size:0.95rem; cursor:pointer; padding:0; margin-bottom:1.1rem;}
  .back-btn:hover{color:var(--ink);}
  .lesson-title{font-family:'Markazi Text', serif; font-weight:700; font-size:1.55rem; margin:0 0 1.1rem; text-align:center;}
  .advice-box{background:var(--sea-light); border-right:4px solid var(--sea); border-radius:6px; padding:0.9rem 1.1rem; margin-bottom:1.4rem; font-size:0.92rem;}
  .advice-box .advice-label{font-weight:700; color:var(--sea); display:block; margin-bottom:0.3rem; font-size:0.88rem;}

  .tab-bar{display:flex; gap:6px; overflow-x:auto; padding-bottom:6px; margin-bottom:1.3rem; -webkit-overflow-scrolling:touch;}
  .tab-btn{flex:0 0 auto; background:var(--card); border:none; border-radius:20px; padding:0.5rem 1rem; font-family:'Noto Sans Arabic', sans-serif; font-size:0.88rem; color:var(--ink-soft); cursor:pointer; white-space:nowrap;}
  .tab-btn.active{background:var(--ink); color:var(--paper);}
  #section-content{min-height:200px;}

  /* ---- Quiz / conjugate / prefix box ---- */
  .quiz-box{background:var(--card); border-radius:10px; padding:1.3rem 1.1rem; text-align:center;}
  .quiz-top{display:flex; justify-content:space-between; font-size:0.88rem; color:var(--ink-soft); margin-bottom:0.7rem;}
  .quiz-arabic{font-size:1.3rem; font-weight:600; margin:0 0 0.25rem;}
  .quiz-hint{color:var(--muted); margin:0 0 0.9rem; direction:ltr; font-family:'Markazi Text', serif; font-size:1.1rem;}
  .quiz-box input[type="text"]{width:100%; padding:0.55rem 0.75rem; font-size:1.05rem; border:1px solid var(--line); border-radius:6px; direction:ltr; text-align:left; font-family:'Markazi Text', serif; background:var(--paper); color:var(--ink);}
  .quiz-box input[type="text"]:focus{outline:none; border-color:var(--ink);}
  .quiz-error{min-height:1.1rem; font-size:0.82rem; color:var(--pen); margin:0.3rem 0 0;}
  .quiz-btn{width:100%; margin-top:0.65rem; padding:0.65rem; font-size:0.98rem; font-family:'Noto Sans Arabic', sans-serif; border:none; border-radius:6px; background:var(--ink); color:var(--paper); cursor:pointer;}
  .quiz-btn:hover{background:var(--ink-soft);}
  .quiz-btn-next{background:var(--pen);}
  .quiz-btn-next:hover{background:var(--pen-soft);}
  .quiz-feedback{min-height:1.3rem; font-size:0.98rem; font-weight:600; margin:0.75rem 0 0;}
  .quiz-sub{font-size:0.82rem; color:var(--muted); margin:-0.6rem 0 1rem;}

  /* ---- Fishing ---- */
  .fish-box{background:linear-gradient(180deg, var(--sea-light) 0%, var(--sand) 100%); border-radius:10px; padding:1.3rem 1.1rem 1.5rem; text-align:center; overflow:hidden;}
  .fish-top{display:flex; justify-content:space-between; font-size:0.88rem; color:var(--ink-soft); margin-bottom:0.5rem;}
  .fish-arabic{font-size:1.3rem; font-weight:600; margin:0 0 0.9rem;}
  .slots{display:flex; justify-content:center; gap:5px; margin-bottom:1.3rem; flex-wrap:wrap; direction:ltr;}
  .slot{min-width:1.8rem; height:2.3rem; border-bottom:3px solid var(--sea); display:flex; align-items:center; justify-content:center; font-family:'Markazi Text', serif; font-weight:700; font-size:1.35rem;}
  .slot.space{border-bottom:none; min-width:0.8rem;}
  .pond{display:flex; justify-content:center; gap:9px; flex-wrap:wrap; direction:ltr; margin-bottom:0.5rem;}
  .fish-letter{width:2.6rem; height:2rem; border:none; border-radius:50% 50% 45% 45% / 60% 60% 40% 40%; background:var(--sea); color:#fff; font-family:'Markazi Text', serif; font-weight:700; font-size:1.15rem; cursor:pointer; animation:bob 2.2s ease-in-out infinite;}
  .fish-letter:nth-child(odd){animation-delay:0.4s;} .fish-letter:nth-child(3n){animation-delay:0.8s;}
  .fish-letter[disabled]{background:var(--line); color:var(--muted); cursor:default; animation:none;}
  .fish-letter.wrong{animation:shake 0.35s;}
  @keyframes bob{0%,100%{transform:translateY(0);} 50%{transform:translateY(-5px);}}
  @keyframes shake{0%,100%{transform:translateX(0);} 25%{transform:translateX(-5px);} 75%{transform:translateX(5px);}}
  .fish-feedback{min-height:1.3rem; font-size:0.98rem; font-weight:600; margin:0.75rem 0 0.3rem;}
  .fish-next-btn{padding:0.55rem 1.3rem; font-size:0.9rem; font-family:'Noto Sans Arabic', sans-serif; border:none; border-radius:6px; background:var(--sea); color:#fff; cursor:pointer; display:none;}

  /* ---- MC quiz ---- */
  .mc-box{background:var(--card); border-radius:10px; padding:1.3rem 1.1rem;}
  .mc-top{display:flex; justify-content:space-between; font-size:0.88rem; color:var(--ink-soft); margin-bottom:0.8rem;}
  .mc-question{font-size:1.05rem; font-weight:600; margin:0 0 1rem; text-align:center; direction:ltr;}
  .mc-options{display:grid; grid-template-columns:1fr 1fr; gap:8px; margin-bottom:0.6rem;}
  .mc-opt{padding:0.6rem 0.5rem; border:1px solid var(--line); border-radius:6px; background:var(--paper); color:var(--ink); font-family:'Markazi Text', serif; font-size:1.05rem; cursor:pointer; direction:ltr;}
  .mc-opt.correct{background:var(--ok); color:#fff; border-color:var(--ok);}
  .mc-opt.incorrect{background:var(--pen); color:#fff; border-color:var(--pen);}
  .mc-feedback{min-height:1.3rem; font-size:0.95rem; font-weight:600; text-align:center; margin:0.6rem 0 0;}
  .mc-next{width:100%; margin-top:0.6rem; padding:0.6rem; border:none; border-radius:6px; background:var(--pen); color:#fff; font-family:'Noto Sans Arabic', sans-serif; cursor:pointer; display:none;}

  /* ---- Order game ---- */
  .order-box{background:var(--card); border-radius:10px; padding:1.3rem 1.1rem;}
  .order-slots{display:flex; flex-direction:column; gap:6px; margin-bottom:1rem;}
  .order-slot{background:var(--paper); border:1px dashed var(--line); border-radius:6px; padding:0.6rem 0.8rem; min-height:1.4rem; font-size:0.92rem;}
  .order-pool{display:flex; flex-direction:column; gap:6px;}
  .order-item{background:var(--sea); color:#fff; border:none; border-radius:6px; padding:0.6rem 0.8rem; font-size:0.92rem; cursor:pointer; text-align:right; font-family:'Noto Sans Arabic', sans-serif;}
  .order-item[disabled]{opacity:0; pointer-events:none;}
  .order-feedback{min-height:1.3rem; font-size:0.95rem; font-weight:600; text-align:center; margin-top:0.7rem;}
</style>
</head>
<body>
<div class="sheet">

  <div id="view-login" class="view active">
    <div class="login-card">
      <h1>بوابة الطالب</h1>
      <p>اكتب اسمك للدخول إلى دروسك</p>
      <input type="text" id="student-name-input" placeholder="اسم الطالب">
      <p class="login-error" id="login-error"></p>
      <button class="primary-btn" id="login-btn">دخول</button>
    </div>
  </div>

  <div id="view-unit" class="view">
    <h1 id="unit-title"></h1>
    <p class="greeting" id="greeting"></p>
    <div class="lesson-list" id="lesson-list"></div>
  </div>

  <div id="view-lesson" class="view">
    <button class="back-btn" id="back-btn">→ رجوع للوحدة</button>
    <h2 class="lesson-title" id="lesson-title"></h2>
    <div class="advice-box"><span class="advice-label">نصيحة لولي الأمر</span><span id="lesson-advice"></span></div>
    <div class="tab-bar" id="tab-bar"></div>
    <div id="section-content"></div>
  </div>

</div>

<script>
/* ============================================================
   LESSON DATA
   ============================================================ */
const unit = {
  title: "الوحدة الثانية",
  lessons: [
    {
      id: 1,
      title: "الدرس الأول: Helping the Community",
      advice: "لا تجمعي كل كلمات الدرس مع بعض. ابدئي بتبويب «المفردات الأساسية» (الأفعال الست) لحاله لين يثبت، وبعدين انتقلي لتبويب «مفردات إضافية»، وبعدين «الصفات». تصريف الماضي خليه بجلسة منفصلة، وفعل أو فعلين باليوم بس.",
      sections: [
        { type:"vocab", title:"المفردات الأساسية", words:[
          {en:"clean",ar:"ينظف"},{en:"plant",ar:"يزرع"},{en:"collect",ar:"يجمع"},
          {en:"help",ar:"يساعد"},{en:"feed",ar:"يطعم"},{en:"volunteer",ar:"يتطوع"}
        ]},
        { type:"vocab", title:"مفردات إضافية", words:[
          {en:"community",ar:"مجتمع"},{en:"trash",ar:"قمامة"},{en:"streets",ar:"شوارع"},
          {en:"trees",ar:"أشجار"},{en:"dogs",ar:"كلاب"},{en:"cats",ar:"قطط"},
          {en:"both",ar:"كلا"},{en:"neighbors",ar:"جيران"},{en:"clothes",ar:"ملابس"},
          {en:"people",ar:"أشخاص/ناس"},{en:"food",ar:"طعام"},{en:"community park",ar:"حديقة مجتمعية"}
        ]},
        { type:"vocab", title:"الصفات", words:[
          {en:"happy",ar:"سعيد"},{en:"great",ar:"عظيم/رائع"},{en:"nice",ar:"جميل/لطيف"}
        ]},
        { type:"conjugate", title:"تصريف الأفعال", words:[
          {en:"clean",ar:"ينظف",past:"cleaned"},{en:"help",ar:"يساعد",past:"helped"},
          {en:"plant",ar:"يزرع",past:"planted"},{en:"volunteer",ar:"يتطوع",past:"volunteered"},
          {en:"collect",ar:"يجمع",past:"collected"},{en:"need",ar:"يحتاج",past:"needed"},
          {en:"feed",ar:"يطعم",past:"fed"},{en:"give",ar:"يعطي",past:"gave"},
          {en:"make",ar:"يجعل",past:"made"},{en:"do",ar:"يفعل",past:"did"},{en:"feel",ar:"يشعر",past:"felt"}
        ]},
        { type:"mc", title:"جمل", items:[
          { q:"Adam cleans ___ from the streets and plants trees in the park.", options:["trash","cars","cats","dogs"], answer:0 },
          { q:"He also feeds ___ and cats.", options:["cars","dogs","trees","food"], answer:1 },
          { q:"Adam's sister helps their ___.", options:["neighbors","factories","forest","roads"], answer:0 },
          { q:"Amira collects ___ and gives them to people who need them.", options:["clothes","cotton","trees","cars"], answer:0 }
        ]}
      ]
    },
    {
      id: 2,
      title: "الدرس الثاني: Community Problems and Solutions",
      advice: "كلمات هذا الدرس أسماء ملموسة وسهلة بالصور، بس فيه أفعال شاذة أكتر بتصريف الماضي (know, throw, take, have). ركزي فعل أو اثنين بالأسبوع بدل حفظهم كلهم دفعة وحدة، واستخدمي تبويب الجمل حتى يتعرف على الكلمة جوا سياق مش لحالها بس.",
      sections: [
        { type:"vocab", title:"المفردات", words:[
          {en:"problems",ar:"مشكلات"},{en:"solutions",ar:"حلول"},{en:"traffic",ar:"حركة المرور"},
          {en:"school bus",ar:"أتوبيس المدرسة"},{en:"cars",ar:"سيارات"},{en:"road",ar:"طريق"},
          {en:"instead",ar:"بدلاً من"},{en:"trash",ar:"قمامة"},{en:"bins",ar:"صناديق قمامة"},
          {en:"ground",ar:"أرض"},{en:"everywhere",ar:"كل مكان"},{en:"especially",ar:"خصوصًا"},
          {en:"quickly",ar:"بسرعة"},{en:"anymore",ar:"بعد الآن"},{en:"schools",ar:"مدارس"}
        ]},
        { type:"vocab", title:"الصفات", words:[
          {en:"fewer",ar:"أقل"},{en:"dirty",ar:"قذر/متسخ"},{en:"new",ar:"جديد"}
        ]},
        { type:"conjugate", title:"تصريف الأفعال", words:[
          {en:"discuss",ar:"يناقش",past:"discussed"},{en:"fix",ar:"يصلح",past:"fixed"},
          {en:"solve",ar:"يحل",past:"solved"},{en:"look",ar:"يبدو",past:"looked"},
          {en:"move",ar:"يتحرك",past:"moved"},{en:"have",ar:"يمتلك",past:"had"},
          {en:"take",ar:"يأخذ",past:"took"},{en:"know",ar:"يعرف",past:"knew"},
          {en:"put",ar:"يضع",past:"put"},{en:"throw",ar:"يرمي",past:"threw"}
        ]},
        { type:"mc", title:"جمل", items:[
          { q:"Ali and Mona are talking about problems in their ___.", options:["community","traffic","school","park"], answer:0 },
          { q:"The first problem is ___, especially near schools in the morning.", options:["trash","traffic","schools","roads"], answer:1 },
          { q:"Ali suggests using the school ___ instead of cars to reduce traffic.", options:["bus","road","park","factory"], answer:0 },
          { q:"Ali and his neighbors solved it by putting new ___ everywhere.", options:["bins","trees","cars","schools"], answer:0 }
        ]}
      ]
    },
    {
      id: 3,
      title: "الدرس الثالث: Egypt: My Culture",
      advice: "هذا أثقل درس بالوحدة. لا تفتحي كل التبويبات بنفس الجلسة — يوم لأماكن/مهن، يوم لملابس/ثقافة، يوم للصفات والأفعال، ويوم لوحده للقواعد والبادئات لأنها مهارة مختلفة تمامًا عن الحفظ. تبويب النطق (f/v) بسيط وممكن يصير كمراجعة سريعة بين الجلسات.",
      sections: [
        { type:"vocab", title:"أماكن ومهن", words:[
          {en:"regions",ar:"مناطق"},{en:"north",ar:"شمال"},{en:"south",ar:"جنوب"},
          {en:"farmers",ar:"مزارعون"},{en:"rice",ar:"أرز"},{en:"cotton",ar:"قطن"},
          {en:"factories",ar:"مصانع"},{en:"crafts",ar:"حرف يدوية"},{en:"sugarcane",ar:"قصب السكر"},
          {en:"harvest",ar:"موسم حصاد"},{en:"pottery",ar:"فخار"},{en:"carpets",ar:"سجاد"},
          {en:"Upper Egypt",ar:"صعيد مصر"},{en:"the Delta",ar:"الدلتا"}
        ]},
        { type:"vocab", title:"ثقافة وملابس", words:[
          {en:"traditions",ar:"تقاليد"},{en:"culture",ar:"ثقافة"},{en:"decorations",ar:"زخارف"},
          {en:"songs",ar:"أغاني"},{en:"stories",ar:"قصص"},{en:"designs",ar:"تصاميم"},
          {en:"galabeyas",ar:"جلاليب"},{en:"pants",ar:"بناطيل"},{en:"shirts",ar:"قمصان"},
          {en:"dresses",ar:"فساتين"},{en:"outfits",ar:"ملابس/أزياء"},{en:"events",ar:"أحداث/مناسبات"},
          {en:"turbans",ar:"عمائم"},{en:"differences",ar:"اختلافات"},{en:"Spring Festival",ar:"مهرجان الربيع"}
        ]},
        { type:"vocab", title:"الصفات", words:[
          {en:"special",ar:"مميز/خاص"},{en:"colorful",ar:"مُلوّن"},{en:"traditional",ar:"تقليدي"},
          {en:"bright",ar:"زاهٍ"},{en:"modern",ar:"حديث/عصري"},{en:"stylish",ar:"أنيق"}
        ]},
        { type:"conjugate", title:"تصريف الأفعال", words:[
          {en:"celebrate",ar:"يحتفل",past:"celebrated"},{en:"work",ar:"يعمل",past:"worked"},
          {en:"share",ar:"يشارك",past:"shared"},{en:"weave",ar:"ينسج",past:"wove"},
          {en:"sing",ar:"يغني",past:"sang"},{en:"wear",ar:"يرتدي",past:"wore"}
        ]},
        { type:"mc", title:"القواعد (المضارع البسيط)", items:[
          { q:"Cars ___ move quickly in the morning.", options:["don't","doesn't","isn't","aren't"], answer:0 },
          { q:"She ___ need to use cars every day.", options:["don't","doesn't","isn't","aren't"], answer:1 },
          { q:"___ you know how to solve this problem?", options:["Do","Does","Is","Are"], answer:0 },
          { q:"___ Mona go to school by bus?", options:["Do","Does","Is","Are"], answer:1 },
          { q:"I like coffee, but I ___ like tea.", options:["doesn't","isn't","don't","aren't"], answer:2 },
          { q:"Do you ___ to school every day?", options:["go","going","went","goes"], answer:0 },
          { q:"He doesn't ___ French.", options:["speaking","speak","speaks","spoke"], answer:1 }
        ]},
        { type:"prefix", title:"البادئات (dis / il / ir)", words:[
          {en:"like",ar:"يحب",prefix:"dis",answer:"dislike"},
          {en:"appear",ar:"يظهر",prefix:"dis",answer:"disappear"},
          {en:"honest",ar:"أمين",prefix:"dis",answer:"dishonest"},
          {en:"legal",ar:"قانوني",prefix:"il",answer:"illegal"},
          {en:"logical",ar:"منطقي",prefix:"il",answer:"illogical"},
          {en:"regular",ar:"منتظم",prefix:"ir",answer:"irregular"},
          {en:"responsible",ar:"مسؤول",prefix:"ir",answer:"irresponsible"},
          {en:"relevant",ar:"مناسب/له علاقة",prefix:"ir",answer:"irrelevant"}
        ]},
        { type:"mc", title:"تمارين البادئات", items:[
          { q:"What he says is ___; it doesn't make sense.", options:["dislike","disappear","logical","illogical"], answer:3 },
          { q:"He is ___. He always tells lies.", options:["honest","dishonest","responsible","irrelevant"], answer:1 },
          { q:"The students are ___ (responsible). Their classroom isn't clean.", options:["responsible","irresponsible","disresponsible","unresponsible"], answer:1 },
          { q:"Driving too fast is ___ (legal).", options:["legal","dislegal","illegal","irlegal"], answer:2 },
          { q:"The rabbit ___ (appeared) into the hat. We couldn't see it.", options:["appeared","disappeared","irappeared","illappeared"], answer:1 }
        ]},
        { type:"mc", title:"النطق (f / v)", items:[
          { q:"أي كلمة صوتها الأول مختلف؟ factory – van – flag – frog", options:["factory","van","flag","frog"], answer:1 },
          { q:"أي كلمة صوتها الأول مختلف؟ violin – vest – view – forest", options:["violin","vest","view","forest"], answer:3 },
          { q:"أي كلمة صوتها الأول مختلف؟ forest – frog – vest – flag", options:["forest","frog","vest","flag"], answer:2 }
        ]},
        { type:"mc", title:"جمل الفهم", items:[
          { q:"The Delta and Upper Egypt are two special ___.", options:["regions","streets","buildings","rivers"], answer:0 },
          { q:"They make pottery and ___ carpets.", options:["sing","grow","weave","wear"], answer:2 },
          { q:"Egyptians are ___ of their culture.", options:["stylish","colorful","bright","proud"], answer:3 }
        ]}
      ]
    },
    {
      id: 4,
      title: "الدرسان الرابع والخامس: Diary Entry & Poster",
      advice: "هذا الجزء مش بس مفردات، فيه مهارة كتابة مذكرة بأربع خطوات ثابتة. دربيه يحفظ ترتيب الخطوات الأربعة زي قصة قصيرة (تبويب «ترتيب خطوات الكتابة») قبل أي شي، وبعدين المفردات، وبعدين جرّبوا يطبقوا نفس الخطوات على موضوع بسيط من يومه.",
      sections: [
        { type:"vocab", title:"المفردات", words:[
          {en:"diary",ar:"مذكرة"},{en:"history",ar:"تاريخ"},{en:"neighborhood",ar:"حي"},
          {en:"houses",ar:"منازل"},{en:"safely",ar:"بأمان"},{en:"stalls",ar:"أكشاك"},
          {en:"buildings",ar:"مبانٍ"},{en:"photos",ar:"صور"},{en:"plastic",ar:"بلاستيك"},
          {en:"supermarket",ar:"سوبر ماركت"},{en:"train station",ar:"محطة قطار"},{en:"air pollution",ar:"تلوث الهواء"}
        ]},
        { type:"vocab", title:"الصفات", words:[
          {en:"old",ar:"قديم"},{en:"wooden",ar:"خشبي"},{en:"rich",ar:"غني"},
          {en:"different",ar:"مختلف"},{en:"fresh",ar:"طازج"},{en:"tall",ar:"طويل"}
        ]},
        { type:"conjugate", title:"تصريف الأفعال", words:[
          {en:"play",ar:"يلعب",past:"played"},{en:"stop",ar:"يوقف",past:"stopped"},
          {en:"walk",ar:"يمشي",past:"walked"},{en:"cycle",ar:"يركب دراجة",past:"cycled"},
          {en:"use",ar:"يستخدم",past:"used"},{en:"tell",ar:"يخبر",past:"told"},
          {en:"sell",ar:"يبيع",past:"sold"},{en:"see",ar:"يرى",past:"saw"},
          {en:"show",ar:"يعرض",past:"showed"},{en:"build",ar:"يبني",past:"built"}
        ]},
        { type:"order", title:"ترتيب خطوات كتابة المذكرة", items:[
          "ابدأ بالتاريخ (Start with the date)",
          "اكتب تحية (Write a greeting)",
          "أضف تفاصيل: مع من تحدثت، وماذا سمعت، وكيف شعرت (Add details)",
          "انهِ بعبارة ختامية (End with a closing)"
        ]},
        { type:"mc", title:"جمل", items:[
          { q:"We waited for the train at the train ___.", options:["stall","station","street","store"], answer:1 },
          { q:"I live in a quiet ___.", options:["neighborhood","story","photo","history"], answer:0 },
          { q:"Walk or ___ to school to stop air pollution.", options:["sell","show","see","cycle"], answer:3 }
        ]}
      ]
    }
  ]
};

/* ============================================================
   VIEW SWITCHING
   ============================================================ */
let studentName = "";
const views = { login: document.getElementById("view-login"), unit: document.getElementById("view-unit"), lesson: document.getElementById("view-lesson") };
function showView(name){ Object.values(views).forEach(v => v.classList.remove("active")); views[name].classList.add("active"); }

document.getElementById("login-btn").addEventListener("click", () => {
  const val = document.getElementById("student-name-input").value.trim();
  const errorEl = document.getElementById("login-error");
  if (!val){ errorEl.textContent = "اكتب اسمك أولاً"; return; }
  errorEl.textContent = "";
  studentName = val;
  renderUnit();
  showView("unit");
});
document.getElementById("student-name-input").addEventListener("keydown", e => { if (e.key === "Enter") document.getElementById("login-btn").click(); });

function renderUnit(){
  document.getElementById("unit-title").textContent = unit.title;
  document.getElementById("greeting").textContent = "أهلًا " + studentName;
  const listEl = document.getElementById("lesson-list");
  listEl.innerHTML = "";
  unit.lessons.forEach(lesson => {
    const btn = document.createElement("button");
    btn.className = "lesson-card";
    btn.innerHTML = "<span>" + lesson.title + "</span><span class='arrow'>‹</span>";
    btn.addEventListener("click", () => openLesson(lesson));
    listEl.appendChild(btn);
  });
}
document.getElementById("back-btn").addEventListener("click", () => showView("unit"));

function openLesson(lesson){
  document.getElementById("lesson-title").textContent = lesson.title;
  document.getElementById("lesson-advice").textContent = lesson.advice;
  const tabBar = document.getElementById("tab-bar");
  const contentEl = document.getElementById("section-content");
  tabBar.innerHTML = "";
  lesson.sections.forEach((section, i) => {
    const tab = document.createElement("button");
    tab.className = "tab-btn" + (i === 0 ? " active" : "");
    tab.textContent = section.title;
    tab.addEventListener("click", () => {
      [...tabBar.children].forEach(t => t.classList.remove("active"));
      tab.classList.add("active");
      renderSection(section, contentEl);
    });
    tabBar.appendChild(tab);
  });
  renderSection(lesson.sections[0], contentEl);
  showView("lesson");
}

function renderSection(section, container){
  container.innerHTML = "";
  if (section.type === "vocab"){
    container.appendChild(buildSpellingQuiz(section.words));
    const spacer = document.createElement("div"); spacer.style.height = "1.3rem"; container.appendChild(spacer);
    container.appendChild(buildFishingGame(section.words));
  } else if (section.type === "conjugate"){
    container.appendChild(buildConjugateQuiz(section.words));
  } else if (section.type === "mc"){
    container.appendChild(buildMCQuiz(section.items));
  } else if (section.type === "prefix"){
    container.appendChild(buildPrefixQuiz(section.words));
  } else if (section.type === "order"){
    container.appendChild(buildOrderGame(section.items));
  }
}

/* ============================================================
   GENERIC BUILDERS
   ============================================================ */
function shuffle(arr){ return [...arr].sort(() => Math.random() - 0.5); }
function makeHint(word){ return word[0] + " " + "_ ".repeat(word.length - 1).trim(); }

/* ---- Spelling quiz (Arabic -> type English) ---- */
function buildSpellingQuiz(words){
  const wrapper = document.createElement("div");
  wrapper.className = "quiz-box";
  wrapper.innerHTML = `
    <p class="quiz-sub">تمرين الكتابة</p>
    <div class="quiz-top"><span class="q-progress"></span><span class="q-score"></span></div>
    <p class="quiz-arabic"></p><p class="quiz-hint"></p>
    <input type="text" class="q-input" placeholder="اكتب الكلمة بالإنجليزي" autocomplete="off">
    <p class="quiz-error"></p>
    <button class="quiz-btn q-check">تحقق</button>
    <p class="quiz-feedback"></p>
    <button class="quiz-btn quiz-btn-next q-next" style="display:none;">التالي</button>`;
  const els = {
    progress: wrapper.querySelector(".q-progress"), score: wrapper.querySelector(".q-score"),
    arabic: wrapper.querySelector(".quiz-arabic"), hint: wrapper.querySelector(".quiz-hint"),
    input: wrapper.querySelector(".q-input"), error: wrapper.querySelector(".quiz-error"),
    checkBtn: wrapper.querySelector(".q-check"), feedback: wrapper.querySelector(".quiz-feedback"),
    nextBtn: wrapper.querySelector(".q-next")
  };
  let idx = 0, score = 0, checked = false;
  function load(){
    checked = false;
    const cur = words[idx];
    els.arabic.textContent = cur.ar;
    els.hint.textContent = "يبدأ بـ: " + makeHint(cur.en);
    els.input.value = ""; els.input.disabled = false;
    els.error.textContent = ""; els.feedback.textContent = "";
    els.checkBtn.style.display = "block"; els.nextBtn.style.display = "none";
    els.progress.textContent = "كلمة " + (idx+1) + " من " + words.length;
    els.score.textContent = "النقاط: " + score;
  }
  function check(){
    if (checked) return;
    const val = els.input.value.trim();
    if (!val){ els.error.textContent = "اكتب الكلمة أولاً"; return; }
    els.error.textContent = ""; checked = true;
    const cur = words[idx];
    if (val.toLowerCase() === cur.en.toLowerCase()){
      score++; els.feedback.style.color = "var(--ok)"; els.feedback.textContent = "صح! " + cur.en;
    } else {
      els.feedback.style.color = "var(--pen)"; els.feedback.textContent = "لأ، الصحيح هو: " + cur.en;
    }
    els.score.textContent = "النقاط: " + score;
    els.input.disabled = true; els.checkBtn.style.display = "none";
    els.nextBtn.style.display = "block";
    els.nextBtn.textContent = idx < words.length - 1 ? "الكلمة التالية" : "إعادة التمرين";
  }
  els.checkBtn.addEventListener("click", check);
  els.input.addEventListener("keydown", e => { if (e.key === "Enter") check(); });
  els.nextBtn.addEventListener("click", () => {
    if (idx < words.length - 1){ idx++; } else { idx = 0; score = 0; }
    load();
  });
  load();
  return wrapper;
}

/* ---- Letter fishing game (handles spaces) ---- */
function buildFishingGame(words){
  const wrapper = document.createElement("div");
  wrapper.className = "fish-box";
  wrapper.innerHTML = `
    <p class="quiz-sub">صيد الأحرف</p>
    <div class="fish-top"><span class="f-progress"></span><span class="f-score"></span></div>
    <p class="fish-arabic"></p>
    <div class="slots"></div>
    <div class="pond"></div>
    <p class="fish-feedback"></p>
    <button class="fish-next-btn">التالي</button>`;
  const els = {
    progress: wrapper.querySelector(".f-progress"), score: wrapper.querySelector(".f-score"),
    arabic: wrapper.querySelector(".fish-arabic"), slots: wrapper.querySelector(".slots"),
    pond: wrapper.querySelector(".pond"), feedback: wrapper.querySelector(".fish-feedback"),
    nextBtn: wrapper.querySelector(".fish-next-btn")
  };
  let idx = 0, score = 0, pos = 0;
  function advancePastSpaces(word){
    while (pos < word.length && word[pos] === " "){
      const s = els.slots.children[pos];
      if (s) s.textContent = "";
      pos++;
    }
  }
  function load(){
    pos = 0;
    els.feedback.textContent = ""; els.nextBtn.style.display = "none";
    const cur = words[idx];
    els.arabic.textContent = cur.ar;
    els.progress.textContent = "كلمة " + (idx+1) + " من " + words.length;
    els.score.textContent = "النقاط: " + score;
    els.slots.innerHTML = "";
    for (let i = 0; i < cur.en.length; i++){
      const s = document.createElement("div");
      s.className = "slot" + (cur.en[i] === " " ? " space" : "");
      els.slots.appendChild(s);
    }
    advancePastSpaces(cur.en);
    const lettersData = shuffle(cur.en.split("").filter(ch => ch !== " ").map((ch,i)=>({ch,used:false})));
    els.pond.innerHTML = "";
    lettersData.forEach(item => {
      const btn = document.createElement("button");
      btn.className = "fish-letter";
      btn.textContent = item.ch;
      btn.addEventListener("click", () => catchLetter(item, btn, cur));
      els.pond.appendChild(btn);
    });
  }
  function catchLetter(item, btn, cur){
    if (item.used) return;
    const expected = cur.en[pos];
    if (item.ch === expected){
      item.used = true; btn.disabled = true;
      els.slots.children[pos].textContent = item.ch;
      pos++;
      advancePastSpaces(cur.en);
      if (pos >= cur.en.length){
        score++;
        els.feedback.style.color = "var(--ok)";
        els.feedback.textContent = "أحسنت! الكلمة: " + cur.en;
        els.score.textContent = "النقاط: " + score;
        els.nextBtn.style.display = "inline-block";
        els.nextBtn.textContent = idx < words.length - 1 ? "الكلمة التالية" : "إعادة التمرين";
      }
    } else {
      btn.classList.add("wrong");
      setTimeout(() => btn.classList.remove("wrong"), 350);
    }
  }
  els.nextBtn.addEventListener("click", () => {
    if (idx < words.length - 1){ idx++; } else { idx = 0; score = 0; }
    load();
  });
  load();
  return wrapper;
}

/* ---- Conjugate quiz (present shown -> type past) ---- */
function buildConjugateQuiz(words){
  const wrapper = document.createElement("div");
  wrapper.className = "quiz-box";
  wrapper.innerHTML = `
    <p class="quiz-sub">اكتب صيغة الماضي</p>
    <div class="quiz-top"><span class="q-progress"></span><span class="q-score"></span></div>
    <p class="quiz-arabic"></p><p class="quiz-hint"></p>
    <input type="text" class="q-input" placeholder="اكتب الفعل بصيغة الماضي" autocomplete="off">
    <p class="quiz-error"></p>
    <button class="quiz-btn q-check">تحقق</button>
    <p class="quiz-feedback"></p>
    <button class="quiz-btn quiz-btn-next q-next" style="display:none;">التالي</button>`;
  const els = {
    progress: wrapper.querySelector(".q-progress"), score: wrapper.querySelector(".q-score"),
    arabic: wrapper.querySelector(".quiz-arabic"), hint: wrapper.querySelector(".quiz-hint"),
    input: wrapper.querySelector(".q-input"), error: wrapper.querySelector(".quiz-error"),
    checkBtn: wrapper.querySelector(".q-check"), feedback: wrapper.querySelector(".quiz-feedback"),
    nextBtn: wrapper.querySelector(".q-next")
  };
  let idx = 0, score = 0, checked = false;
  function load(){
    checked = false;
    const cur = words[idx];
    els.arabic.textContent = cur.en + "  (" + cur.ar + ")";
    els.hint.textContent = "الماضي يبدأ بـ: " + makeHint(cur.past);
    els.input.value = ""; els.input.disabled = false;
    els.error.textContent = ""; els.feedback.textContent = "";
    els.checkBtn.style.display = "block"; els.nextBtn.style.display = "none";
    els.progress.textContent = "فعل " + (idx+1) + " من " + words.length;
    els.score.textContent = "النقاط: " + score;
  }
  function check(){
    if (checked) return;
    const val = els.input.value.trim();
    if (!val){ els.error.textContent = "اكتب الفعل أولاً"; return; }
    els.error.textContent = ""; checked = true;
    const cur = words[idx];
    if (val.toLowerCase() === cur.past.toLowerCase()){
      score++; els.feedback.style.color = "var(--ok)"; els.feedback.textContent = "صح! " + cur.past;
    } else {
      els.feedback.style.color = "var(--pen)"; els.feedback.textContent = "لأ، الصحيح هو: " + cur.past;
    }
    els.score.textContent = "النقاط: " + score;
    els.input.disabled = true; els.checkBtn.style.display = "none";
    els.nextBtn.style.display = "block";
    els.nextBtn.textContent = idx < words.length - 1 ? "الفعل التالي" : "إعادة التمرين";
  }
  els.checkBtn.addEventListener("click", check);
  els.input.addEventListener("keydown", e => { if (e.key === "Enter") check(); });
  els.nextBtn.addEventListener("click", () => {
    if (idx < words.length - 1){ idx++; } else { idx = 0; score = 0; }
    load();
  });
  load();
  return wrapper;
}

/* ---- Prefix quiz (root shown -> type prefixed opposite) ---- */
function buildPrefixQuiz(words){
  const wrapper = document.createElement("div");
  wrapper.className = "quiz-box";
  wrapper.innerHTML = `
    <p class="quiz-sub">اكتب الكلمة المضادة</p>
    <div class="quiz-top"><span class="q-progress"></span><span class="q-score"></span></div>
    <p class="quiz-arabic"></p><p class="quiz-hint"></p>
    <input type="text" class="q-input" placeholder="اكتب الكلمة المضادة" autocomplete="off">
    <p class="quiz-error"></p>
    <button class="quiz-btn q-check">تحقق</button>
    <p class="quiz-feedback"></p>
    <button class="quiz-btn quiz-btn-next q-next" style="display:none;">التالي</button>`;
  const els = {
    progress: wrapper.querySelector(".q-progress"), score: wrapper.querySelector(".q-score"),
    arabic: wrapper.querySelector(".quiz-arabic"), hint: wrapper.querySelector(".quiz-hint"),
    input: wrapper.querySelector(".q-input"), error: wrapper.querySelector(".quiz-error"),
    checkBtn: wrapper.querySelector(".q-check"), feedback: wrapper.querySelector(".quiz-feedback"),
    nextBtn: wrapper.querySelector(".q-next")
  };
  let idx = 0, score = 0, checked = false;
  function load(){
    checked = false;
    const cur = words[idx];
    els.arabic.textContent = cur.en + "  (" + cur.ar + ")";
    els.hint.textContent = "أضيفي البادئة: " + cur.prefix + "-";
    els.input.value = ""; els.input.disabled = false;
    els.error.textContent = ""; els.feedback.textContent = "";
    els.checkBtn.style.display = "block"; els.nextBtn.style.display = "none";
    els.progress.textContent = "كلمة " + (idx+1) + " من " + words.length;
    els.score.textContent = "النقاط: " + score;
  }
  function check(){
    if (checked) return;
    const val = els.input.value.trim();
    if (!val){ els.error.textContent = "اكتب الكلمة أولاً"; return; }
    els.error.textContent = ""; checked = true;
    const cur = words[idx];
    if (val.toLowerCase() === cur.answer.toLowerCase()){
      score++; els.feedback.style.color = "var(--ok)"; els.feedback.textContent = "صح! " + cur.answer;
    } else {
      els.feedback.style.color = "var(--pen)"; els.feedback.textContent = "لأ، الصحيح هو: " + cur.answer;
    }
    els.score.textContent = "النقاط: " + score;
    els.input.disabled = true; els.checkBtn.style.display = "none";
    els.nextBtn.style.display = "block";
    els.nextBtn.textContent = idx < words.length - 1 ? "الكلمة التالية" : "إعادة التمرين";
  }
  els.checkBtn.addEventListener("click", check);
  els.input.addEventListener("keydown", e => { if (e.key === "Enter") check(); });
  els.nextBtn.addEventListener("click", () => {
    if (idx < words.length - 1){ idx++; } else { idx = 0; score = 0; }
    load();
  });
  load();
  return wrapper;
}

/* ---- Multiple choice quiz ---- */
function buildMCQuiz(items){
  const wrapper = document.createElement("div");
  wrapper.className = "mc-box";
  wrapper.innerHTML = `
    <div class="mc-top"><span class="m-progress"></span><span class="m-score"></span></div>
    <p class="mc-question"></p>
    <div class="mc-options"></div>
    <p class="mc-feedback"></p>
    <button class="mc-next">السؤال التالي</button>`;
  const els = {
    progress: wrapper.querySelector(".m-progress"), score: wrapper.querySelector(".m-score"),
    question: wrapper.querySelector(".mc-question"), options: wrapper.querySelector(".mc-options"),
    feedback: wrapper.querySelector(".mc-feedback"), nextBtn: wrapper.querySelector(".mc-next")
  };
  let idx = 0, score = 0, answered = false;
  function load(){
    answered = false;
    const cur = items[idx];
    els.question.textContent = cur.q;
    els.progress.textContent = "سؤال " + (idx+1) + " من " + items.length;
    els.score.textContent = "النقاط: " + score;
    els.feedback.textContent = ""; els.nextBtn.style.display = "none";
    els.options.innerHTML = "";
    cur.options.forEach((opt, i) => {
      const btn = document.createElement("button");
      btn.className = "mc-opt";
      btn.textContent = opt;
      btn.addEventListener("click", () => selectAnswer(i, cur, btn));
      els.options.appendChild(btn);
    });
  }
  function selectAnswer(i, cur, btn){
    if (answered) return;
    answered = true;
    const correct = i === cur.answer;
    if (correct) score++;
    [...els.options.children].forEach((b, bi) => {
      if (bi === cur.answer) b.classList.add("correct");
      else if (bi === i) b.classList.add("incorrect");
    });
    els.feedback.style.color = correct ? "var(--ok)" : "var(--pen)";
    els.feedback.textContent = correct ? "صح!" : "لأ، الصحيح: " + cur.options[cur.answer];
    els.score.textContent = "النقاط: " + score;
    els.nextBtn.style.display = "block";
    els.nextBtn.textContent = idx < items.length - 1 ? "السؤال التالي" : "إعادة التمرين";
  }
  els.nextBtn.addEventListener("click", () => {
    if (idx < items.length - 1){ idx++; } else { idx = 0; score = 0; }
    load();
  });
  load();
  return wrapper;
}

/* ---- Order game (tap phrases in correct order) ---- */
function buildOrderGame(items){
  const wrapper = document.createElement("div");
  wrapper.className = "order-box";
  wrapper.innerHTML = `
    <div class="order-slots"></div>
    <div class="order-pool"></div>
    <p class="order-feedback"></p>`;
  const els = { slots: wrapper.querySelector(".order-slots"), pool: wrapper.querySelector(".order-pool"), feedback: wrapper.querySelector(".order-feedback") };
  let pos = 0;
  items.forEach(() => {
    const s = document.createElement("div");
    s.className = "order-slot";
    els.slots.appendChild(s);
  });
  const shuffled = shuffle(items.map((text,i) => ({text, correctIndex:i, used:false})));
  shuffled.forEach(item => {
    const btn = document.createElement("button");
    btn.className = "order-item";
    btn.textContent = item.text;
    btn.addEventListener("click", () => {
      if (item.used) return;
      if (item.correctIndex === pos){
        item.used = true;
        els.slots.children[pos].textContent = (pos+1) + ". " + item.text;
        btn.setAttribute("disabled", "true");
        pos++;
        if (pos === items.length){
          els.feedback.style.color = "var(--ok)";
          els.feedback.textContent = "أحسنت! هذا هو الترتيب الصحيح.";
        }
      } else {
        btn.classList.add("wrong");
        setTimeout(() => btn.classList.remove("wrong"), 350);
      }
    });
    els.pool.appendChild(btn);
  });
  return wrapper;
}
</script>
</body>
</html>
