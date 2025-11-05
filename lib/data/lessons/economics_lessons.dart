import '../../models/lesson_model.dart';

class EconomicsLessons {
  static List<LessonModel> getAllLessons() {
    return [
      _lesson1(),
      _lesson2(),
      _lesson3(),
      _lesson4(),
      _lesson5(),
      _lesson6(),
      _lesson7(),
      _lesson8(),
      _lesson9(),
      _lesson10(),
    ];
  }

  static Quiz? getQuiz(int lessonNumber) {
    switch (lessonNumber) {
      case 1:
        return _quiz1();
      case 2:
        return _quiz2();
      case 3:
        return _quiz3();
      case 4:
        return _quiz4();
      case 5:
        return _quiz5();
      case 6:
        return _quiz6();
      case 7:
        return _quiz7();
      case 8:
        return _quiz8();
      case 9:
        return _quiz9();
      case 10:
        return _quiz10();
      default:
        return null;
    }
  }

  // LESSON 1: Introduction to Economics
  static LessonModel _lesson1() {
    return const LessonModel(
      id: 'econ_1',
      pillarId: 'economics',
      lessonNumber: 1,
      title: 'Introduction to Economics',
      description:
          'Discover what economics is all about and why it matters in your daily life.',
      content: '''
# Welcome to Economics! 🎯

## What is Economics?

Economics is the study of how people make decisions about using limited resources to satisfy unlimited wants and needs. In simpler terms, it's about making choices!

Every day, you make economic decisions:
- Should I buy a coffee or save my money?
- Should I spend time studying or watching Netflix?
- Should I buy the new phone now or wait for a sale?

## The Three Big Questions

Economics tries to answer three fundamental questions:

1. **WHAT to produce?**
   What goods and services should we make? iPhones or Android phones? Electric cars or gas cars?

2. **HOW to produce?**
   What methods and resources should we use? Machines or human labor? Renewable energy or fossil fuels?

3. **FOR WHOM to produce?**
   Who gets the goods and services we make? Who can afford them? How do we distribute them fairly?

## Scarcity: The Central Economic Problem

**Scarcity** means we have limited resources but unlimited wants. There's never enough of everything to satisfy everyone completely.

Think about it:
- There are only 24 hours in a day (limited time)
- There's only so much money in your wallet (limited income)
- There are limited seats at your favorite concert (limited supply)

Because of scarcity, we must make **choices**. And every choice has a cost...

## Opportunity Cost

**Opportunity cost** is what you give up when you make a choice. It's the value of the next best alternative.

**Example:** You have $50 and free time on Saturday.

- Option A: Buy a new video game ($50)
- Option B: Go to a concert ($50)
- Option C: Save the money and hang out with friends (free)

If you choose the video game, your opportunity cost is:
- You give up the concert
- You give up saving the money
- You give up the specific experience of hanging with friends

The opportunity cost is whichever option you valued MOST among the alternatives.

## Microeconomics vs. Macroeconomics

Economics is divided into two main branches:

**Microeconomics** 🔬
- Studies individual people and businesses
- Focuses on specific markets
- Examples: How does Apple price the iPhone? Why did gas prices go up?

**Macroeconomics** 🌍
- Studies the economy as a whole
- Focuses on big-picture issues
- Examples: Why is unemployment high? What causes inflation? How do we measure economic growth?

## Why Economics Matters

Understanding economics helps you:
- Make better personal financial decisions
- Understand how businesses work
- Comprehend news about the economy
- Vote on economic policies
- Become a more informed citizen

Economics isn't just about money—it's about making smart choices in a world of scarcity!
      ''',
      sections: [
        LessonSection(
          title: 'What is Economics?',
          content:
              'Economics is the study of how people make decisions about using limited resources.',
          type: LessonSectionType.text,
        ),
        LessonSection(
          title: 'Scarcity and Choice',
          content:
              'Scarcity forces us to make choices because resources are limited.',
          type: LessonSectionType.text,
        ),
        LessonSection(
          title: 'Opportunity Cost',
          content: 'The value of what you give up when making a choice.',
          type: LessonSectionType.text,
        ),
      ],
      difficulty: 'beginner',
      estimatedMinutes: 12,
      learningObjectives: [
        'Define economics and explain why it matters',
        'Understand the concept of scarcity',
        'Calculate opportunity cost in real-world scenarios',
        'Distinguish between microeconomics and macroeconomics',
      ],
      keyTerms: [
        'Economics',
        'Scarcity',
        'Opportunity Cost',
        'Microeconomics',
        'Macroeconomics',
      ],
      coinsReward: 50,
      xpReward: 100,
      requiresPreviousLesson: false,
    );
  }

  static Quiz _quiz1() {
    return const Quiz(
      id: 'econ_quiz_1',
      lessonId: 'econ_1',
      pillarId: 'economics',
      lessonNumber: 1,
      questions: [
        QuizQuestion(
          id: 'eq1_1',
          question:
              'What is economics primarily concerned with?',
          type: QuizQuestionType.multipleChoice,
          options: [
            'Making money in the stock market',
            'How people make decisions about using limited resources',
            'Only studying large corporations',
            'Predicting lottery numbers',
          ],
          correctAnswer: 'How people make decisions about using limited resources',
          explanation:
              'Economics is the study of how people, businesses, and governments make decisions about using scarce resources to satisfy unlimited wants and needs.',
        ),
        QuizQuestion(
          id: 'eq1_2',
          question: 'Scarcity exists because:',
          type: QuizQuestionType.multipleChoice,
          options: [
            'People are greedy',
            'Resources are limited but wants are unlimited',
            'Governments control everything',
            'Only rich people have access to goods',
          ],
          correctAnswer: 'Resources are limited but wants are unlimited',
          explanation:
              'Scarcity is the fundamental economic problem that arises because we have limited resources but unlimited wants.',
        ),
        QuizQuestion(
          id: 'eq1_3',
          question:
              'You have \\$20. You can either buy a book (\\$20) or go to a movie (\\$20). You choose the book. What is your opportunity cost?',
          type: QuizQuestionType.multipleChoice,
          options: [
            'The \\$20 you spent',
            'The movie you gave up',
            'The book you bought',
            'Nothing, because you got what you wanted',
          ],
          correctAnswer: 'The movie you gave up',
          explanation:
              'Opportunity cost is the value of the next best alternative you give up. By choosing the book, you gave up seeing the movie.',
        ),
        QuizQuestion(
          id: 'eq1_4',
          question:
              'Which branch of economics studies the entire economy as a whole?',
          type: QuizQuestionType.multipleChoice,
          options: [
            'Microeconomics',
            'Macroeconomics',
            'Business economics',
            'Personal finance',
          ],
          correctAnswer: 'Macroeconomics',
          explanation:
              'Macroeconomics studies the economy as a whole, including topics like inflation, unemployment, and economic growth.',
        ),
        QuizQuestion(
          id: 'eq1_5',
          question:
              'Which of these is an example of a microeconomic topic?',
          type: QuizQuestionType.multipleChoice,
          options: [
            'National unemployment rate',
            'How a company prices its products',
            'The country\\'s GDP growth',
            'Government budget deficit',
          ],
          correctAnswer: 'How a company prices its products',
          explanation:
              'Microeconomics focuses on individual economic units like households and firms. Company pricing is a micro-level decision.',
        ),
      ],
      totalQuestions: 5,
      timeLimit: 0,
      passingScore: 80,
    );
  }

  // LESSON 2: Supply and Demand Basics
  static LessonModel _lesson2() {
    return const LessonModel(
      id: 'econ_2',
      pillarId: 'economics',
      lessonNumber: 2,
      title: 'Supply and Demand Basics',
      description:
          'Learn how markets work and what determines prices through the powerful forces of supply and demand.',
      content: '''
# Supply and Demand: The Market's Invisible Hand 📊

## What is a Market?

A **market** is any place where buyers and sellers come together to exchange goods and services. This could be:
- A physical store (farmers market, mall)
- An online platform (Amazon, eBay)
- A stock exchange
- Even informal (lemonade stand, garage sale)

Markets exist because people have different wants and different resources. Some people have goods to sell, others want to buy!

## Demand: What Buyers Want

**Demand** is the quantity of a good or service that consumers are willing and able to buy at various prices.

**The Law of Demand:** As price goes UP, quantity demanded goes DOWN (and vice versa).

Why? Because:
- Higher prices make goods less affordable
- People switch to cheaper alternatives
- You get less satisfaction from additional units

**Example:** Pizza 🍕
- At \\$5 per slice: You might buy 4 slices
- At \\$10 per slice: You might only buy 2 slices
- At \\$20 per slice: You might buy 0 slices

## What Shifts Demand?

Demand can increase or decrease due to several factors:

1. **Income Changes**
   - More income → Buy more (normal goods)
   - Less income → Buy less

2. **Price of Related Goods**
   - **Substitutes:** If Coke's price rises, Pepsi's demand increases
   - **Complements:** If gas prices rise, car demand decreases

3. **Consumer Tastes**
   - New trend → Increased demand
   - Out of style → Decreased demand

4. **Expectations**
   - Expecting prices to rise → Buy now (increased demand)
   - Expecting prices to fall → Wait (decreased demand)

5. **Number of Buyers**
   - More people → More demand
   - Fewer people → Less demand

## Supply: What Sellers Offer

**Supply** is the quantity of a good or service that producers are willing and able to sell at various prices.

**The Law of Supply:** As price goes UP, quantity supplied goes UP (and vice versa).

Why? Because:
- Higher prices mean more profit
- Producers can cover higher costs
- More businesses enter the market

**Example:** T-shirt Manufacturing 👕
- At \\$5 per shirt: Make 100 shirts
- At \\$10 per shirt: Make 200 shirts
- At \\$20 per shirt: Make 400 shirts

## What Shifts Supply?

Supply can increase or decrease due to:

1. **Production Costs**
   - Lower costs → More supply
   - Higher costs → Less supply

2. **Technology**
   - Better technology → More efficient → More supply

3. **Number of Sellers**
   - More sellers → More supply
   - Fewer sellers → Less supply

4. **Expectations**
   - Expecting higher prices later → Hold back supply now
   - Expecting lower prices later → Sell more now

5. **Government Policies**
   - Taxes → Less supply
   - Subsidies → More supply

## Market Equilibrium: Where Supply Meets Demand

**Equilibrium** is the price where quantity demanded equals quantity supplied. It's where the market "clears" and everyone who wants to buy at that price can find a seller.

**Example: Sneaker Market** 👟

| Price | Quantity Demanded | Quantity Supplied |
|-------|------------------|-------------------|
| \\$40  | 1000             | 200               |
| \\$60  | 800              | 400               |
| \\$80  | 600              | 600               | ← **EQUILIBRIUM!**
| \\$100 | 400              | 800               |
| \\$120 | 200              | 1000              |

At \\$80, buyers want 600 sneakers and sellers want to sell 600 sneakers. Perfect match!

## What Happens Away from Equilibrium?

**Shortage (Price too low)**
- Quantity demanded > Quantity supplied
- Not enough product for everyone
- Buyers compete → Price rises toward equilibrium
- Example: Concert tickets selling out instantly

**Surplus (Price too high)**
- Quantity supplied > Quantity demanded
- Too much product, not enough buyers
- Sellers compete → Price falls toward equilibrium
- Example: Leftover Halloween candy in November

## Real-World Applications

**Why did the PS5 cost so much when it first came out?**
- High demand (everyone wanted it)
- Low supply (manufacturing constraints)
- Result: Shortage → Prices shot up

**Why are hotel rooms cheaper in off-season?**
- Lower demand (fewer tourists)
- Same supply (same number of rooms)
- Result: Surplus → Hotels lower prices

Understanding supply and demand helps you predict price changes and make smarter purchasing decisions!
      ''',
      sections: [],
      difficulty: 'beginner',
      estimatedMinutes: 15,
      learningObjectives: [
        'Explain the law of demand and law of supply',
        'Identify factors that shift supply and demand curves',
        'Find market equilibrium price and quantity',
        'Analyze shortages and surpluses',
      ],
      keyTerms: [
        'Demand',
        'Supply',
        'Equilibrium',
        'Shortage',
        'Surplus',
        'Substitutes',
        'Complements',
      ],
      coinsReward: 50,
      xpReward: 100,
      requiresPreviousLesson: true,
      prerequisiteLessonNumber: 1,
    );
  }

  static Quiz _quiz2() {
    return const Quiz(
      id: 'econ_quiz_2',
      lessonId: 'econ_2',
      pillarId: 'economics',
      lessonNumber: 2,
      questions: [
        QuizQuestion(
          id: 'eq2_1',
          question: 'According to the law of demand, as price increases:',
          type: QuizQuestionType.multipleChoice,
          options: [
            'Quantity demanded increases',
            'Quantity demanded decreases',
            'Quantity demanded stays the same',
            'Supply increases',
          ],
          correctAnswer: 'Quantity demanded decreases',
          explanation:
              'The law of demand states that as price increases, quantity demanded decreases (inverse relationship).',
        ),
        QuizQuestion(
          id: 'eq2_2',
          question:
              'If the price of coffee increases, what happens to the demand for tea (a substitute)?',
          type: QuizQuestionType.multipleChoice,
          options: [
            'Demand for tea decreases',
            'Demand for tea increases',
            'Demand for tea stays the same',
            'Supply of tea decreases',
          ],
          correctAnswer: 'Demand for tea increases',
          explanation:
              'When the price of a substitute good (coffee) increases, demand for the alternative (tea) increases as people switch.',
        ),
        QuizQuestion(
          id: 'eq2_3',
          question: 'Market equilibrium occurs when:',
          type: QuizQuestionType.multipleChoice,
          options: [
            'Price is at its lowest',
            'Quantity demanded equals quantity supplied',
            'There is a surplus',
            'There is a shortage',
          ],
          correctAnswer: 'Quantity demanded equals quantity supplied',
          explanation:
              'Equilibrium is the price point where the amount buyers want to buy exactly equals the amount sellers want to sell.',
        ),
        QuizQuestion(
          id: 'eq2_4',
          question:
              'A shortage occurs when:',
          type: QuizQuestionType.multipleChoice,
          options: [
            'Price is above equilibrium',
            'Price is below equilibrium',
            'Supply equals demand',
            'No one wants to buy the product',
          ],
          correctAnswer: 'Price is below equilibrium',
          explanation:
              'When price is below equilibrium, quantity demanded exceeds quantity supplied, creating a shortage.',
        ),
        QuizQuestion(
          id: 'eq2_5',
          question:
              'Which would cause the supply curve to shift to the RIGHT (increase)?',
          type: QuizQuestionType.multipleChoice,
          options: [
            'Higher production costs',
            'New technology that reduces production costs',
            'Fewer sellers in the market',
            'Government adds new taxes',
          ],
          correctAnswer: 'New technology that reduces production costs',
          explanation:
              'New technology that lowers costs makes it easier and more profitable to produce, shifting supply to the right (increase).',
        ),
      ],
      totalQuestions: 5,
      timeLimit: 0,
      passingScore: 80,
    );
  }

  // Placeholder lessons 3-10 (to be implemented with full content)
  static LessonModel _lesson3() {
    return const LessonModel(
      id: 'econ_3',
      pillarId: 'economics',
      lessonNumber: 3,
      title: 'Market Equilibrium',
      description: 'Deep dive into how markets find balance.',
      content: 'Full lesson content coming soon...',
      difficulty: 'intermediate',
      estimatedMinutes: 15,
      learningObjectives: [],
      keyTerms: [],
      requiresPreviousLesson: true,
      prerequisiteLessonNumber: 2,
    );
  }

  static Quiz _quiz3() {
    return const Quiz(
      id: 'econ_quiz_3',
      lessonId: 'econ_3',
      pillarId: 'economics',
      lessonNumber: 3,
      questions: [],
    );
  }

  static LessonModel _lesson4() {
    return const LessonModel(
      id: 'econ_4',
      pillarId: 'economics',
      lessonNumber: 4,
      title: 'Elasticity Concepts',
      description: 'Learn how responsive demand and supply are to price changes.',
      content: 'Full lesson content coming soon...',
      difficulty: 'intermediate',
      estimatedMinutes: 15,
      learningObjectives: [],
      keyTerms: [],
      requiresPreviousLesson: true,
      prerequisiteLessonNumber: 3,
    );
  }

  static Quiz _quiz4() {
    return const Quiz(
      id: 'econ_quiz_4',
      lessonId: 'econ_4',
      pillarId: 'economics',
      lessonNumber: 4,
      questions: [],
    );
  }

  static LessonModel _lesson5() {
    return const LessonModel(
      id: 'econ_5',
      pillarId: 'economics',
      lessonNumber: 5,
      title: 'Perfect Competition',
      description: 'Understand the ideal market structure.',
      content: 'Full lesson content coming soon...',
      difficulty: 'intermediate',
      estimatedMinutes: 15,
      learningObjectives: [],
      keyTerms: [],
      requiresPreviousLesson: true,
      prerequisiteLessonNumber: 4,
    );
  }

  static Quiz _quiz5() {
    return const Quiz(
      id: 'econ_quiz_5',
      lessonId: 'econ_5',
      pillarId: 'economics',
      lessonNumber: 5,
      questions: [],
    );
  }

  static LessonModel _lesson6() {
    return const LessonModel(
      id: 'econ_6',
      pillarId: 'economics',
      lessonNumber: 6,
      title: 'Monopolies and Oligopolies',
      description: 'Explore different market structures and their impacts.',
      content: 'Full lesson content coming soon...',
      difficulty: 'intermediate',
      estimatedMinutes: 15,
      learningObjectives: [],
      keyTerms: [],
      requiresPreviousLesson: true,
      prerequisiteLessonNumber: 5,
    );
  }

  static Quiz _quiz6() {
    return const Quiz(
      id: 'econ_quiz_6',
      lessonId: 'econ_6',
      pillarId: 'economics',
      lessonNumber: 6,
      questions: [],
    );
  }

  static LessonModel _lesson7() {
    return const LessonModel(
      id: 'econ_7',
      pillarId: 'economics',
      lessonNumber: 7,
      title: 'Introduction to Macroeconomics',
      description: 'Step back and look at the economy as a whole.',
      content: 'Full lesson content coming soon...',
      difficulty: 'intermediate',
      estimatedMinutes: 15,
      learningObjectives: [],
      keyTerms: [],
      requiresPreviousLesson: true,
      prerequisiteLessonNumber: 6,
    );
  }

  static Quiz _quiz7() {
    return const Quiz(
      id: 'econ_quiz_7',
      lessonId: 'econ_7',
      pillarId: 'economics',
      lessonNumber: 7,
      questions: [],
    );
  }

  static LessonModel _lesson8() {
    return const LessonModel(
      id: 'econ_8',
      pillarId: 'economics',
      lessonNumber: 8,
      title: 'GDP and Economic Indicators',
      description: 'Learn how we measure economic health and growth.',
      content: 'Full lesson content coming soon...',
      difficulty: 'intermediate',
      estimatedMinutes: 15,
      learningObjectives: [],
      keyTerms: [],
      requiresPreviousLesson: true,
      prerequisiteLessonNumber: 7,
    );
  }

  static Quiz _quiz8() {
    return const Quiz(
      id: 'econ_quiz_8',
      lessonId: 'econ_8',
      pillarId: 'economics',
      lessonNumber: 8,
      questions: [],
    );
  }

  static LessonModel _lesson9() {
    return const LessonModel(
      id: 'econ_9',
      pillarId: 'economics',
      lessonNumber: 9,
      title: 'Inflation and Deflation',
      description: 'Understand why prices change over time.',
      content: 'Full lesson content coming soon...',
      difficulty: 'intermediate',
      estimatedMinutes: 15,
      learningObjectives: [],
      keyTerms: [],
      requiresPreviousLesson: true,
      prerequisiteLessonNumber: 8,
    );
  }

  static Quiz _quiz9() {
    return const Quiz(
      id: 'econ_quiz_9',
      lessonId: 'econ_9',
      pillarId: 'economics',
      lessonNumber: 9,
      questions: [],
    );
  }

  static LessonModel _lesson10() {
    return const LessonModel(
      id: 'econ_10',
      pillarId: 'economics',
      lessonNumber: 10,
      title: 'Monetary and Fiscal Policy',
      description: 'Discover how governments manage the economy.',
      content: 'Full lesson content coming soon...',
      difficulty: 'advanced',
      estimatedMinutes: 15,
      learningObjectives: [],
      keyTerms: [],
      requiresPreviousLesson: true,
      prerequisiteLessonNumber: 9,
    );
  }

  static Quiz _quiz10() {
    return const Quiz(
      id: 'econ_quiz_10',
      lessonId: 'econ_10',
      pillarId: 'economics',
      lessonNumber: 10,
      questions: [],
    );
  }
}
