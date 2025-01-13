import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';

class FAQScreen extends StatelessWidget {
  // Liste des questions et réponses
  final List<Map<String, String>> faqData = [
    {
      "question": "Who is obligated to pay zakat?",
      "answer":
          "Every Muslim who owns wealth equal to or above the nisab (minimum zakatable wealth)."
    },
    {
      "question": "When is zakat due?",
      "answer":
          "Zakat is due once every Hijri year at the end of Alhawl (the Hijri year)."
    },
    {
      "question": "How is zakat calculated?",
      "answer":
          "The Zakatuk app calculates your zakat by summing up your assets and savings, deducting liabilities, and informing you of the amount due."
    },
    {
      "question": "What are zakatable assets?",
      "answer":
          "Zakatable assets include cash, gold, silver, investments, business profits, and more."
    },
    {
      "question": "What is nisab?",
      "answer":
          "Nisab is the minimum amount of wealth required to qualify for zakat. For example, in Tunisia in 2024, the nisab for zakat on money is equivalent to 85 grams of gold or 595 grams of silver, approximately 19,933.872 TND."
    },
    {
      "question": "Can I track my zakat payments?",
      "answer":
          "Yes, the app helps you record and track all your zakat payments."
    },
    {
      "question": "What happens if I forget to pay zakat?",
      "answer":
          "Zakatuk sends reminders to ensure you don’t miss your zakat obligations."
    },
    {
      "question": "How do I distribute my zakat?",
      "answer":
          "By paying zakat through the app and selecting beneficiary categories, Zakatuk ensures lawful distribution to the eight zakat-eligible groups mentioned in the Quran: \n\"إِنَّمَا الصَّدَقَاتُ لِلْفُقَرَاءِ وَالْمَسَاكِينِ وَالْعَامِلِينَ عَلَيْهَا وَالْمُؤَلَّفَةِ قُلُوبُهُمْ وَفِي الرِّقَابِ وَالْغَارِمِينَ وَفِي سَبِيلِ اللَّهِ وَابْنِ السَّبِيلِ فَرِيضَةً مِنَ اللَّهِ وَاللَّهُ عَلِيمٌ حَكِيمٌ\" (التوبة 60)."
    },
    {
      "question": "How can I track the impact of my zakat?",
      "answer":
          "Zakatuk provides detailed reports on the impact of your zakat, including the date, location of delivery, and messages from beneficiaries."
    },
    {
      "question": "How does Zakatuk handle my financial data?",
      "answer":
          "Zakatuk encrypts and securely stores all user data to ensure privacy and safety."
    },
    {
      "question": "I own a business. Can I calculate my company’s zakat?",
      "answer":
          "Yes, Zakatuk offers advanced tools and access to experts specialized in corporate zakat and Islamic law to assist businesses in calculating and managing zakat."
    },
    {
      "question": "How can I become a corporate zakat accounting specialist?",
      "answer":
          "Zakatuk organizes regular training programs, available both online and in-person, offering certification in corporate zakat accounting."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        title: Text('Q&A - Zakat'),
        backgroundColor: secondaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: faqData.length,
          itemBuilder: (context, index) {
            final item = faqData[index];
            return FAQItem(
                question: item["question"]!, answer: item["answer"]!);
          },
        ),
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF010F07),
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Color.fromARGB(255, 156, 88, 10),
                  ),
                ],
              ),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  widget.answer,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 145, 88, 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
