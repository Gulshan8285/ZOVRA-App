import '../models/address_model.dart';
import '../models/banner_model.dart';
import '../models/booking_model.dart';
import '../models/cart_item.dart';
import '../models/coupon_model.dart';
import '../models/notification_item.dart';
import '../models/review_model.dart';
import '../models/service_category.dart';
import '../models/service_item.dart';
import '../models/support_ticket.dart';

class InitialData {
  /// 10 Exclusive Massage Subcategories (Strictly Massage Only for Initial Release)
  static List<ServiceCategory> getCategories() {
    return const [
      ServiceCategory(
        id: 'cat_full_body',
        name: 'Full Body Massage',
        iconName: 'spa',
        imageUrl: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?auto=format&fit=crop&w=1000&q=85',
        description: 'Comprehensive head-to-toe therapeutic acupressure & tension relief.',
        sortOrder: 1,
        startingPrice: 849,
        serviceCount: 2,
        rating: 4.9,
      ),
      ServiceCategory(
        id: 'cat_swedish',
        name: 'Swedish Massage',
        iconName: 'self_improvement',
        imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=1000&q=85',
        description: 'Gentle long gliding strokes for maximum mental calm and circulation.',
        sortOrder: 2,
        startingPrice: 1249,
        serviceCount: 1,
        rating: 4.9,
      ),
      ServiceCategory(
        id: 'cat_deep_tissue',
        name: 'Deep Tissue Massage',
        iconName: 'fitness_center',
        imageUrl: 'https://images.unsplash.com/photo-1574680096145-d05b474e2155?auto=format&fit=crop&w=1000&q=85',
        description: 'Firm trigger-point pressure to dissolve stubborn knots & lumbar pain.',
        sortOrder: 3,
        startingPrice: 1549,
        serviceCount: 1,
        rating: 4.9,
      ),
      ServiceCategory(
        id: 'cat_aromatherapy',
        name: 'Aromatherapy Massage',
        iconName: 'local_florist',
        imageUrl: 'https://images.unsplash.com/photo-1583416750470-965b2707b355?auto=format&fit=crop&w=1000&q=85',
        description: 'French organic essential oils to induce deep REM sleep and de-stress.',
        sortOrder: 4,
        startingPrice: 2049,
        serviceCount: 1,
        rating: 4.9,
      ),
      ServiceCategory(
        id: 'cat_relaxation',
        name: 'Relaxation Massage',
        iconName: 'bedtime',
        imageUrl: 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?auto=format&fit=crop&w=1000&q=85',
        description: 'Soothing rhythmic kneading with ambient spa soundscapes.',
        sortOrder: 5,
        startingPrice: 1199,
        serviceCount: 1,
        rating: 4.8,
      ),
      ServiceCategory(
        id: 'cat_head_shoulder',
        name: 'Head & Shoulder Massage',
        iconName: 'psychology',
        imageUrl: 'https://plus.unsplash.com/premium_photo-1661505103296-a23f027f2dd1?auto=format&fit=crop&w=1000&q=85',
        description: 'Targeted relief for corporate fatigue, migraine and stiff neck.',
        sortOrder: 6,
        startingPrice: 749,
        serviceCount: 1,
        rating: 4.9,
      ),
      ServiceCategory(
        id: 'cat_back_neck',
        name: 'Back & Neck Massage',
        iconName: 'airline_seat_recline_extra',
        imageUrl: 'https://plus.unsplash.com/premium_photo-1702598974693-9cdcbea7d2bb?auto=format&fit=crop&w=1000&q=85',
        description: 'Postural correction and lower spinal decompression treatment.',
        sortOrder: 7,
        startingPrice: 799,
        serviceCount: 1,
        rating: 4.8,
      ),
      ServiceCategory(
        id: 'cat_foot_reflexology',
        name: 'Foot Reflexology',
        iconName: 'do_not_step',
        imageUrl: 'https://images.unsplash.com/photo-1519824145371-296894a0daa9?auto=format&fit=crop&w=1000&q=85',
        description: 'Ancient Thai plantar pressure-point activation & lymphatic drainage.',
        sortOrder: 8,
        startingPrice: 899,
        serviceCount: 1,
        rating: 4.9,
      ),
      ServiceCategory(
        id: 'cat_couple',
        name: 'Couple Massage',
        iconName: 'favorite',
        imageUrl: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?auto=format&fit=crop&w=1000&q=85',
        description: 'Synchronized luxury spa therapy for two in your private suite.',
        sortOrder: 9,
        startingPrice: 2499,
        serviceCount: 1,
        rating: 5.0,
      ),
      ServiceCategory(
        id: 'cat_spa_exp',
        name: 'Premium Spa Experience',
        iconName: 'diamond',
        imageUrl: 'https://images.unsplash.com/photo-1591343395082-e120087004b4?auto=format&fit=crop&w=1000&q=85',
        description: 'Flagship 5-Star holistic ritual with body polish, steam & hot stones.',
        sortOrder: 10,
        startingPrice: 2999,
        serviceCount: 1,
        rating: 5.0,
      ),
    ];
  }

  /// All Rich Massage Services with exact user pricing for 1-Hour sessions
  static List<ServiceItem> getServices() {
    return const [
      // 1. Dry Massage (Full Body, No-Oil) - Exact requested ₹849 for 1 Hr
      ServiceItem(
        id: 'srv_dry_massage',
        categoryId: 'cat_full_body',
        name: 'Dry Massage (No-Oil Acupressure)',
        shortDescription: 'Full body stretching & acupressure without oil. Ideal for quick fatigue recovery.',
        fullDescription:
            'A fully clothed, zero-residue therapeutic massage combining ancient Thai acupressure points, rhythmic joint mobilisations, and gentle spinal decompression. Perfect for active professionals requiring immediate physical recharge.',
        imageUrl: 'https://images.unsplash.com/photo-1519823551278-64ac92734fb1?auto=format&fit=crop&w=1200&q=80',
        originalPrice: 1199,
        discountedPrice: 849,
        durationMinutes: 60,
        rating: 4.9,
        reviewCount: 420,
        isPopular: true,
        isBestSeller: true,
        whatsIncluded: [
          'Portable padded spa bed brought by therapist',
          'Fresh single-use sanitized disposable sheets & headrest',
          'Full-body Thai stretching and muscle meridian trigger release',
          'Aromatherapy room diffuser with calming organic lemongrass mist',
        ],
        benefits: [
          'Decompresses lumbar spine & tight shoulder blade fascia',
          'Zero oil residue – get dressed and return to your routine instantly',
          'Improves full-body blood circulation and postural alignment',
        ],
        preparationInstructions: [
          'Wear loose, comfortable workout clothing or pajamas.',
          'Keep a 6x4 ft area clear for the portable massage bed.',
          'Avoid heavy meals 45 minutes prior to the therapy.',
        ],
        faqs: [
          {
            'q': 'Do I need to undress for this massage?',
            'a': 'No. Dry Massage is performed completely clothed in comfortable attire without any oils.'
          },
          {
            'q': 'Does the therapist bring the massage table?',
            'a': 'Yes, our certified male wellness partner brings a professional portable spa bed, disposable hygienic linens, and ambient audio.'
          }
        ],
        packages: [
          ServicePackage(
            id: 'pkg_dry_30',
            title: 'Express Relief',
            durationText: '30 mins',
            originalPrice: 799,
            discountedPrice: 549,
            description: 'Focused back, shoulder and neck tension release.',
          ),
          ServicePackage(
            id: 'pkg_dry_60',
            title: 'Standard Dry Session',
            durationText: '60 mins',
            originalPrice: 1199,
            discountedPrice: 849,
            description: 'Full body acupressure, limb stretching & spinal decompression.',
          ),
          ServicePackage(
            id: 'pkg_dry_90',
            title: 'Deep Restoration',
            durationText: '90 mins',
            originalPrice: 1699,
            discountedPrice: 1249,
            description: 'Extended full body meridian work with reflexology points.',
          ),
        ],
        addOns: [
          ServiceAddOn(
            id: 'addon_potli',
            name: 'Hot Herbal Potli Fomentation',
            price: 349,
            description: 'Ayurvedic warm herbal compress for stiff muscles.',
          ),
          ServiceAddOn(
            id: 'addon_head_15',
            name: '15-Min Scalp De-stress',
            price: 249,
            description: 'Targeted temple and occipital pressure point release.',
          ),
        ],
      ),

      // 2. Swedish Massage - Exact requested ₹1249 for 1 Hr
      ServiceItem(
        id: 'srv_swedish_massage',
        categoryId: 'cat_swedish',
        name: 'Classic Swedish Massage',
        shortDescription: 'Gentle long effleurage strokes with warm almond oil for mental clarity and relaxation.',
        fullDescription:
            'The gold standard of therapeutic relaxation. Utilising long, flowing strokes (effleurage), gentle kneading (petrissage), and light friction over major muscle groups to drain lymphatic build-up and induce total tranquility.',
        imageUrl: 'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2?auto=format&fit=crop&w=1200&q=80',
        originalPrice: 1799,
        discountedPrice: 1249,
        durationMinutes: 60,
        rating: 4.9,
        reviewCount: 310,
        isPopular: true,
        whatsIncluded: [
          'Warm sweet almond and jojoba carrier oil blend',
          'Professional foldable spa table with sanitary draping',
          'Soothing 432Hz ambient spa music',
          'Warm steamed towel wipe-down after service',
        ],
        benefits: [
          'Decreases cortisol (stress hormone) significantly',
          'Promotes lymphatic drainage and oxygenates muscle tissues',
          'Relieves mental burnout and promotes uninterrupted sleep',
        ],
        preparationInstructions: [
          'Take a warm shower 20 minutes prior for optimal oil absorption.',
          'Inform the therapist of any skin sensitivities or allergies.',
        ],
        faqs: [
          {
            'q': 'What oils are used?',
            'a': 'We use 100% pure, cold-pressed sweet almond and jojoba oils that are light, non-comedogenic, and hypoallergenic.'
          }
        ],
        packages: [
          ServicePackage(
            id: 'pkg_swe_45',
            title: 'Calm Starter',
            durationText: '45 mins',
            originalPrice: 1399,
            discountedPrice: 999,
            description: 'Upper body and lower leg gentle relaxation.',
          ),
          ServicePackage(
            id: 'pkg_swe_60',
            title: 'Complete Swedish Session',
            durationText: '60 mins',
            originalPrice: 1799,
            discountedPrice: 1249,
            description: 'Full body therapeutic relaxation with warm oil.',
          ),
          ServicePackage(
            id: 'pkg_swe_90',
            title: 'Deep Serenity Ritual',
            durationText: '90 mins',
            originalPrice: 2499,
            discountedPrice: 1749,
            description: 'Unrushed 90-minute whole-body effleurage & head massage.',
          ),
        ],
        addOns: [
          ServiceAddOn(
            id: 'addon_lavender',
            name: 'French Lavender Essential Oil',
            price: 249,
            description: 'Calming aromatherapeutic oil infusion.',
          ),
        ],
      ),

      // 3. Deep Tissue Massage - Exact requested ₹1549 for 1 Hr
      ServiceItem(
        id: 'srv_deep_tissue',
        categoryId: 'cat_deep_tissue',
        name: 'Deep Tissue Muscle Release',
        shortDescription: 'Intense slow-stroke pressure targeting connective tissues, lumbar stiffness and chronic knots.',
        fullDescription:
            'A focused, corrective treatment targeting deep sub-layers of muscle and fascia. Highly recommended for gym enthusiasts, marathoners, and individuals enduring desk-bound spinal tension.',
        imageUrl: 'https://images.unsplash.com/photo-1600334129128-685c5582fd35?auto=format&fit=crop&w=1000&q=85',
        originalPrice: 2199,
        discountedPrice: 1549,
        durationMinutes: 60,
        rating: 4.9,
        reviewCount: 580,
        isPopular: true,
        isTrending: true,
        isBestSeller: true,
        whatsIncluded: [
          'High-potency botanical muscle-rub with wintergreen and eucalyptus',
          'Elbow, forearm, and thumb trigger-point compression',
          'Portable orthopedic treatment bed with memory foam cushioning',
          'Hot towel application on trapezius and lower back',
        ],
        benefits: [
          'Breaks down chronic adhesions (muscle knots)',
          'Improves joint range of motion and alleviates sciatica pain',
          'Speeds up post-workout lactic acid clearance',
        ],
        preparationInstructions: [
          'Hydrate well before and after the session.',
          'Communicate your desired pressure level directly to the therapist.',
        ],
        faqs: [
          {
            'q': 'Will it hurt?',
            'a': 'You may feel a "good hurt" as stubborn trigger points release. Our therapist regularly checks your comfort level.'
          }
        ],
        packages: [
          ServicePackage(
            id: 'pkg_dt_45',
            title: 'Target Knot Release',
            durationText: '45 mins',
            originalPrice: 1699,
            discountedPrice: 1199,
            description: 'Focused exclusively on upper back, neck and lumbar spine.',
          ),
          ServicePackage(
            id: 'pkg_dt_60',
            title: 'Standard Deep Tissue',
            durationText: '60 mins',
            originalPrice: 2199,
            discountedPrice: 1549,
            description: 'Comprehensive full-body deep fascia work.',
          ),
          ServicePackage(
            id: 'pkg_dt_90',
            title: 'Athletic Recovery Overhaul',
            durationText: '90 mins',
            originalPrice: 2999,
            discountedPrice: 2099,
            description: 'Full-body deep tissue plus assisted PNF stretching.',
          ),
        ],
        addOns: [
          ServiceAddOn(
            id: 'addon_arnica',
            name: 'Arnica Pain-Relief Balm',
            price: 299,
            description: 'Anti-inflammatory herbal balm for acute soreness.',
          ),
        ],
      ),

      // 4. Aromatherapy Massage - Exact requested ₹2049 for 1 Hr
      ServiceItem(
        id: 'srv_aromatherapy',
        categoryId: 'cat_aromatherapy',
        name: 'Aromatherapy Sensory Massage',
        shortDescription: 'Holistic healing with therapeutic French essential oils for complete central nervous system reset.',
        fullDescription:
            'A multisensory therapeutic journey combining customized floral and woody essential oils with rhythmic effleurage massage. Designed to lower heart rate variability, balance energy meridians, and restore sound sleep cycles.',
        imageUrl: 'https://images.unsplash.com/photo-1583416750470-965b2707b355?auto=format&fit=crop&w=1000&q=85',
        originalPrice: 2899,
        discountedPrice: 2049,
        durationMinutes: 60,
        rating: 4.9,
        reviewCount: 290,
        isPopular: true,
        isRecommended: true,
        whatsIncluded: [
          'Choice of pure essential oil blend: Lavender/Cedarwood or Bergamot/Ylang',
          'Ultrasonic room diffuser with ambient warm light',
          'Heated spa massage table with pure cotton linens',
          'Scalp and temple pressure-point release',
        ],
        benefits: [
          'Induces deep restorative alpha brainwave state',
          'Clears respiratory channels and calms anxiety',
          'Nourishes and revitalizes dry skin barrier',
        ],
        preparationInstructions: [
          'Leave the essential oils on your skin for at least 2 hours after the session.',
        ],
        faqs: [
          {
            'q': 'Can I choose my aroma?',
            'a': 'Yes, the therapist presents our scent palette at arrival so you can choose based on your mood.'
          }
        ],
        packages: [
          ServicePackage(
            id: 'pkg_aro_60',
            title: 'Signature Aroma Therapy',
            durationText: '60 mins',
            originalPrice: 2899,
            discountedPrice: 2049,
            description: 'Full body essential oil massage with ultrasonic mist.',
          ),
          ServicePackage(
            id: 'pkg_aro_90',
            title: 'Royal Sensory Journey',
            durationText: '90 mins',
            originalPrice: 3899,
            discountedPrice: 2799,
            description: 'Extended full body aroma ritual with marma points and foot massage.',
          ),
        ],
        addOns: [
          ServiceAddOn(
            id: 'addon_eye_pillow',
            name: 'Warm Flaxseed Eye Pillow',
            price: 199,
            description: 'Infused with organic chamomile to soothe strained eyes.',
          ),
        ],
      ),

      // 5. Sports Massage - Exact requested ₹1749 for 1 Hr
      ServiceItem(
        id: 'srv_sports_massage',
        categoryId: 'cat_full_body',
        name: 'Sports Mobility & Recovery Massage',
        shortDescription: 'Assisted stretching, cross-fiber friction, and lactic acid release for runners and gym enthusiasts.',
        fullDescription:
            'Engineered for athletes and active individuals. Combines dynamic PNF stretching, cross-fiber friction, and targeted percussion to release shortened hamstrings, hip flexors, and shoulder joints.',
        imageUrl: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=1000&q=85',
        originalPrice: 2499,
        discountedPrice: 1749,
        durationMinutes: 60,
        rating: 4.8,
        reviewCount: 240,
        isTrending: true,
        whatsIncluded: [
          'Assisted PNF leg, hip, and shoulder joint mobilizations',
          'Targeted percussion and deep friction strokes',
          'Cooling menthol-infused recovery gel application',
        ],
        benefits: [
          'Reduces delayed onset muscle soreness (DOMS) within 24 hours',
          'Increases joint flexibility and prevents sports injuries',
        ],
        preparationInstructions: [
          'Wear athletic shorts or flexible training clothes.',
        ],
        faqs: [
          {
            'q': 'Is this suitable before a marathon?',
            'a': 'Yes! Pre-event sports massage loosens stiff muscles, while post-event accelerates lactic acid drainage.'
          }
        ],
        packages: [
          ServicePackage(
            id: 'pkg_spt_60',
            title: 'Complete Sports Mobility',
            durationText: '60 mins',
            originalPrice: 2499,
            discountedPrice: 1749,
            description: 'Full body athletic stretching & knot release.',
          ),
          ServicePackage(
            id: 'pkg_spt_90',
            title: 'Pro-Athlete Full Restoration',
            durationText: '90 mins',
            originalPrice: 3499,
            discountedPrice: 2399,
            description: 'Comprehensive 90-minute muscle recovery overhaul.',
          ),
        ],
        addOns: [],
      ),

      // 6. Relaxation Massage
      ServiceItem(
        id: 'srv_relaxation',
        categoryId: 'cat_relaxation',
        name: 'Gentle Relaxation Massage',
        shortDescription: 'Light to medium pressure designed to release emotional tension and ease daily stress.',
        fullDescription:
            'A gentle, restorative massage designed to melt away everyday fatigue. Light pressure, warm towels, and soothing strokes restore inner peace.',
        imageUrl: 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?auto=format&fit=crop&w=1000&q=85',
        originalPrice: 1699,
        discountedPrice: 1199,
        durationMinutes: 60,
        rating: 4.8,
        reviewCount: 195,
        whatsIncluded: [
          'Warm cold-pressed coconut & sesame oil',
          'Full body soothing rhythmic therapy',
          'Relaxing ambient music and warm towel cleanse',
        ],
        benefits: [
          'Eases chronic anxiety and muscle stiffness',
          'Improves nighttime sleep depth',
        ],
        preparationInstructions: [
          'Ensure the room temperature is comfortable (23-25°C).',
        ],
        faqs: [],
        packages: [
          ServicePackage(
            id: 'pkg_rel_60',
            title: 'Full Relaxation',
            durationText: '60 mins',
            originalPrice: 1699,
            discountedPrice: 1199,
            description: '60-minute soothing massage for stress relief.',
          ),
          ServicePackage(
            id: 'pkg_rel_90',
            title: 'Extended Calm',
            durationText: '90 mins',
            originalPrice: 2399,
            discountedPrice: 1699,
            description: '90 minutes of total serenity.',
          ),
        ],
        addOns: [],
      ),

      // 7. Head & Shoulder Massage
      ServiceItem(
        id: 'srv_head_shoulder',
        categoryId: 'cat_head_shoulder',
        name: 'Head, Neck & Shoulder Tension Melt',
        shortDescription: 'Targeted acupressure for "tech neck", migraine, occipital tension, and tight trapezius.',
        fullDescription:
            'Specialized ergonomic therapy addressing the consequences of prolonged screen time. Focused kneading across upper trapezius, cervical spine, scalp, and jaw muscles.',
        imageUrl: 'https://plus.unsplash.com/premium_photo-1661505103296-a23f027f2dd1?auto=format&fit=crop&w=1000&q=85',
        originalPrice: 1099,
        discountedPrice: 749,
        durationMinutes: 45,
        rating: 4.9,
        reviewCount: 350,
        isPopular: true,
        whatsIncluded: [
          'Herbal hair tonic or dry scalp acupressure',
          'Cervical traction and neck myofascial release',
          'Upper back and shoulder blade knot breakdown',
        ],
        benefits: [
          'Relieves tension headaches and eye fatigue',
          'Restores full neck rotation without stiffness',
        ],
        preparationInstructions: [
          'Can be performed comfortably on your bed or in a high-back chair.',
        ],
        faqs: [],
        packages: [
          ServicePackage(
            id: 'pkg_hs_30',
            title: 'Quick De-stress',
            durationText: '30 mins',
            originalPrice: 799,
            discountedPrice: 499,
            description: 'Focused 30-min scalp & neck relief.',
          ),
          ServicePackage(
            id: 'pkg_hs_45',
            title: 'Deep Neck & Shoulder',
            durationText: '45 mins',
            originalPrice: 1099,
            discountedPrice: 749,
            description: '45-minute upper body tension release.',
          ),
        ],
        addOns: [],
      ),

      // 8. Back & Neck Massage
      ServiceItem(
        id: 'srv_back_neck',
        categoryId: 'cat_back_neck',
        name: 'Spine & Lumbar Therapeutic Massage',
        shortDescription: 'Dedicated lower and middle back decompression for desk workers and drivers.',
        fullDescription:
            'Targeted lumbar and thoracic care. Eliminates lower back stiffness, decompresses the sacral area, and loosens tight erector spinae muscles.',
        imageUrl: 'https://plus.unsplash.com/premium_photo-1702598974693-9cdcbea7d2bb?auto=format&fit=crop&w=1000&q=85',
        originalPrice: 1199,
        discountedPrice: 799,
        durationMinutes: 45,
        rating: 4.8,
        reviewCount: 220,
        whatsIncluded: [
          'Warm herbal oil fomentation',
          'Lower back thumb and palm compression',
          'Spinal realignment stretching',
        ],
        benefits: [
          'Eliminates lower back ache from prolonged sitting',
          'Improves seated posture and core mobility',
        ],
        preparationInstructions: [],
        faqs: [],
        packages: [
          ServicePackage(
            id: 'pkg_bn_45',
            title: 'Lumbar Focus',
            durationText: '45 mins',
            originalPrice: 1199,
            discountedPrice: 799,
            description: '45-minute spinal therapy.',
          ),
        ],
        addOns: [],
      ),

      // 9. Foot Reflexology
      ServiceItem(
        id: 'srv_foot_reflexology',
        categoryId: 'cat_foot_reflexology',
        name: 'Thai Plantar Foot Reflexology',
        shortDescription: 'Acupressure stick & thumb reflexology stimulation on foot nerve zones.',
        fullDescription:
            'Rooted in ancient Eastern medical traditions. Stimulates over 7,000 nerve endings in each foot corresponding to major internal organs to promote systemic equilibrium.',
        imageUrl: 'https://images.unsplash.com/photo-1519824145371-296894a0daa9?auto=format&fit=crop&w=1000&q=85',
        originalPrice: 1299,
        discountedPrice: 899,
        durationMinutes: 45,
        rating: 4.9,
        reviewCount: 280,
        whatsIncluded: [
          'Warm herbal foot soak & sanitizing wash',
          'Wooden reflexology stick stimulation',
          'Cooling peppermint cream calf massage',
        ],
        benefits: [
          'Reduces calf swelling and plantar fasciitis discomfort',
          'Stimulates overall body vitality',
        ],
        preparationInstructions: [
          'Sit comfortably on your couch or bed with legs elevated.',
        ],
        faqs: [],
        packages: [
          ServicePackage(
            id: 'pkg_ft_45',
            title: 'Plantar Acupressure',
            durationText: '45 mins',
            originalPrice: 1299,
            discountedPrice: 899,
            description: '45-min foot soak and reflexology.',
          ),
          ServicePackage(
            id: 'pkg_ft_60',
            title: 'Reflexology & Calf Drain',
            durationText: '60 mins',
            originalPrice: 1699,
            discountedPrice: 1199,
            description: 'Extended calf lymphatic drainage.',
          ),
        ],
        addOns: [],
      ),

      // 10. Couple Massage
      ServiceItem(
        id: 'srv_couple_massage',
        categoryId: 'cat_couple',
        name: 'ZOVRA Synchronized Couple Massage',
        shortDescription: 'Parallel 5-Star spa therapy in the comfort of your home with two portable beds & therapists.',
        fullDescription:
            'A romantic or rejuvenating spa experience designed for two. Two certified therapists arrive with dual portable spa tables, coordinated aroma diffusers, and matching ambient soundscapes.',
        imageUrl: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?auto=format&fit=crop&w=1000&q=85',
        originalPrice: 3599,
        discountedPrice: 2499,
        durationMinutes: 60,
        rating: 5.0,
        reviewCount: 160,
        isRecommended: true,
        whatsIncluded: [
          'Two certified therapists with dual portable beds',
          'Choice of Swedish or Aromatherapy for each person',
          'Twin essential oil diffusers & complimentary floral mist',
        ],
        benefits: [
          'Shared wellness experience without traveling to an expensive spa',
          'Complete customized pressure level for each individual',
        ],
        preparationInstructions: [
          'Ensure an 8x6 ft area is available to accommodate two spa beds side by side.',
        ],
        faqs: [],
        packages: [
          ServicePackage(
            id: 'pkg_cp_60',
            title: 'Couple Harmony (60 mins)',
            durationText: '60 mins',
            originalPrice: 3599,
            discountedPrice: 2499,
            description: 'Dual full-body synchronized relaxation.',
          ),
          ServicePackage(
            id: 'pkg_cp_90',
            title: 'Royal Couple Spa (90 mins)',
            durationText: '90 mins',
            originalPrice: 4999,
            discountedPrice: 3499,
            description: 'Extended dual therapy with foot reflexology.',
          ),
        ],
        addOns: [],
      ),

      // 11. Premium Spa Experience
      ServiceItem(
        id: 'srv_spa_ritual',
        categoryId: 'cat_spa_exp',
        name: 'ZOVRA Flagship 5-Star Spa Ritual',
        shortDescription: 'The pinnacle of home luxury: Body scrub, deep hot stone massage, steam, and face pack.',
        fullDescription:
            'An opulent 120-minute journey inspired by the finest luxury hotel spas. Includes artisanal Himalayan salt exfoliation, warm volcanic basalt stone therapy, deep kneading, and a 24k gold herbal face mask.',
        imageUrl: 'https://images.unsplash.com/photo-1591343395082-e120087004b4?auto=format&fit=crop&w=1000&q=85',
        originalPrice: 4499,
        discountedPrice: 2999,
        durationMinutes: 90,
        rating: 5.0,
        reviewCount: 180,
        isPopular: true,
        whatsIncluded: [
          'Heated Himalayan pink salt body polish & exfoliation',
          'Heated volcanic basalt hot stone therapy',
          'Full-body Swedish/Deep Tissue hybrid massage',
          'Rejuvenating herbal facial mask and steam wipe-down',
        ],
        benefits: [
          'Deep muscular heat penetration relieves years of spinal tension',
          'Polishes away dead skin cells leaving skin silky and glowing',
          'Complete reset of body, mind, and circadian rhythm',
        ],
        preparationInstructions: [
          'Therapist requires 15 minutes before session to warm basalt stones and set up the luxury table.',
        ],
        faqs: [],
        packages: [
          ServicePackage(
            id: 'pkg_spa_90',
            title: 'Luxury Spa Ritual',
            durationText: '90 mins',
            originalPrice: 4499,
            discountedPrice: 2999,
            description: 'Body polish, hot stone & full-body massage.',
          ),
          ServicePackage(
            id: 'pkg_spa_120',
            title: 'Imperial 2-Hour Spa Journey',
            durationText: '120 mins',
            originalPrice: 5999,
            discountedPrice: 3999,
            description: 'Ultimate 120-minute head-to-toe luxury ritual.',
          ),
        ],
        addOns: [],
      ),
    ];
  }

  /// Promotional Banners matching ZOVRA dark electric blue identity
  static List<BannerModel> getBanners() {
    return const [
      BannerModel(
        id: 'ban_1',
        title: 'Your Personal Wellness, Delivered.',
        subtitle: 'Premium massage and wellness experiences at your doorstep.',
        imageUrl: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?auto=format&fit=crop&w=1200&q=85',
        ctaText: 'Book Now',
        targetCategoryId: 'cat_full_body',
        badgeText: 'ZOVRA 2026',
        discountTag: 'Save up to 35%',
      ),
      BannerModel(
        id: 'ban_2',
        title: 'Deep Tissue Knot Release',
        subtitle: 'Targeted trigger-point pressure to melt away chronic back fatigue.',
        imageUrl: 'https://images.unsplash.com/photo-1600334129128-685c5582fd35?auto=format&fit=crop&w=1200&q=85',
        ctaText: 'Explore Deep Tissue',
        targetCategoryId: 'cat_deep_tissue',
        badgeText: 'CERTIFIED THERAPISTS',
        discountTag: 'Flat ₹650 OFF',
      ),
      BannerModel(
        id: 'ban_3',
        title: 'Sensory Aromatherapy Reset',
        subtitle: 'French lavender and cedarwood essential oils for total mind calm.',
        imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=1200&q=85',
        ctaText: 'View Therapies',
        targetCategoryId: 'cat_aromatherapy',
        badgeText: 'PURE ESSENTIAL OILS',
        discountTag: 'Limited Slots',
      ),
    ];
  }

  /// Dynamic Offers & Coupons (Configurable from backend)
  static List<CouponModel> getCoupons() {
    return [
      CouponModel(
        id: 'coup_1',
        code: 'WELCOME20',
        title: 'Welcome to ZOVRA',
        description: 'Get 20% OFF up to ₹500 on your first doorstep massage therapy.',
        discountType: 'percentage',
        discountValue: 20,
        minOrderAmount: 800,
        maxDiscount: 500,
        validTill: DateTime.now().add(const Duration(days: 30)),
        isActive: true,
      ),
      CouponModel(
        id: 'coup_2',
        code: 'ZOVRA10',
        title: 'ZOVRA Wellness 10%',
        description: '10% instant discount on any full-body or couple massage.',
        discountType: 'percentage',
        discountValue: 10,
        minOrderAmount: 700,
        maxDiscount: 350,
        validTill: DateTime.now().add(const Duration(days: 60)),
        isActive: true,
      ),
      CouponModel(
        id: 'coup_3',
        code: 'WELLNESS15',
        title: 'Deep Recharge 15%',
        description: '15% off on Deep Tissue and Aromatherapy sessions.',
        discountType: 'percentage',
        discountValue: 15,
        minOrderAmount: 1200,
        maxDiscount: 600,
        validTill: DateTime.now().add(const Duration(days: 45)),
        isActive: true,
      ),
      CouponModel(
        id: 'coup_4',
        code: 'SUPER50',
        title: 'Flat ₹50 OFF',
        description: 'Instant ₹50 savings on any booking above ₹499.',
        discountType: 'flat',
        discountValue: 50,
        minOrderAmount: 499,
        maxDiscount: 50,
        validTill: DateTime.now().add(const Duration(days: 90)),
        isActive: true,
      ),
    ];
  }

  /// Seed addresses
  static List<AddressModel> getAddresses() {
    return const [
      AddressModel(
        id: 'addr_1',
        tag: 'Home',
        houseNumber: 'Flat 402, Tower B',
        buildingName: 'The Palm Springs Luxury Residences',
        streetLocality: 'Golf Course Road, Sector 54',
        city: 'Gurugram',
        state: 'Haryana',
        pincode: '122002',
        specialInstructions: 'Please call on arrival. Elevator available.',
        isDefault: true,
        contactPhone: '+91 98765 43210',
      ),
    ];
  }

  /// Sample initial verified reviews across all therapies
  static List<ReviewModel> getReviews() {
    return [
      // 1. Dry Massage Reviews
      ReviewModel(
        id: 'rev_1',
        serviceId: 'srv_dry_massage',
        serviceName: 'Dry Massage (No-Oil Acupressure)',
        userId: 'usr_arjun',
        userName: 'Arjun Khanna',
        rating: 5.0,
        comment:
            'Extremely professional! Vikram arrived right on time with a portable spa bed, fresh disposable linens, and relaxing spa audio. The dry massage acupressure relieved weeks of stiff neck and spinal tightness without any oily mess. 10/10.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isVerifiedBooking: true,
      ),
      ReviewModel(
        id: 'rev_1_b',
        serviceId: 'srv_dry_massage',
        serviceName: 'Dry Massage (No-Oil Acupressure)',
        userId: 'usr_meera',
        userName: 'Meera Sengupta',
        rating: 4.9,
        comment:
            'Perfect choice for midday work fatigue! No oil meant I could get right back to my laptop without needing a shower. Incredible pressure on lower back knots.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        isVerifiedBooking: true,
      ),

      // 2. Swedish Massage Reviews
      ReviewModel(
        id: 'rev_3',
        serviceId: 'srv_swedish_massage',
        serviceName: 'Classic Swedish Massage',
        userId: 'usr_sameer',
        userName: 'Sameer Sen',
        rating: 5.0,
        comment:
            'Unbelievably calming experience. Warm sweet almond oil, soft music, and absolute respect for privacy. Felt like an ultra-luxury retreat.',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        isVerifiedBooking: true,
      ),
      ReviewModel(
        id: 'rev_3_b',
        serviceId: 'srv_swedish_massage',
        serviceName: 'Classic Swedish Massage',
        userId: 'usr_priya',
        userName: 'Priya Nair',
        rating: 4.9,
        comment:
            'The therapist had immaculate hygiene and used sealed single-use kit. The flowing effleurage strokes completely melted my stress away.',
        createdAt: DateTime.now().subtract(const Duration(days: 9)),
        isVerifiedBooking: true,
      ),

      // 3. Deep Tissue Reviews
      ReviewModel(
        id: 'rev_2',
        serviceId: 'srv_deep_tissue',
        serviceName: 'Deep Tissue Knot Release Therapy',
        userId: 'usr_rohit',
        userName: 'Rohit Verma',
        rating: 5.0,
        comment:
            'The deep tissue therapy was outstanding. The therapist addressed every knot in my shoulder blades with perfection. Having a 5-star spa in my own bedroom is incredible.',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        isVerifiedBooking: true,
      ),
      ReviewModel(
        id: 'rev_2_b',
        serviceId: 'srv_deep_tissue',
        serviceName: 'Deep Tissue Knot Release Therapy',
        userId: 'usr_devendra',
        userName: 'Devendra Singh',
        rating: 4.9,
        comment:
            'Firm, targeted pressure exactly as requested. My lower lumbar stiffness has completely vanished after just 1 session.',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        isVerifiedBooking: true,
      ),

      // 4. Aromatherapy Reviews
      ReviewModel(
        id: 'rev_4_a',
        serviceId: 'srv_aromatherapy',
        serviceName: 'Aromatherapy De-Stress Therapy',
        userId: 'usr_ananya',
        userName: 'Ananya Deshmukh',
        rating: 5.0,
        comment:
            'The French organic lavender and ylang-ylang blend was sublime. I experienced the deepest, most restorative sleep that night. Exceptional hotel-standard quality.',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        isVerifiedBooking: true,
      ),
      ReviewModel(
        id: 'rev_4_b',
        serviceId: 'srv_aromatherapy',
        serviceName: 'Aromatherapy De-Stress Therapy',
        userId: 'usr_siddharth',
        userName: 'Siddharth Roy',
        rating: 4.9,
        comment:
            'Therapist brought an ultrasonic aromatic diffuser and soothing ambient soundscapes. Pure luxury without stepping outside.',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        isVerifiedBooking: true,
      ),

      // 5. Sports Massage Reviews
      ReviewModel(
        id: 'rev_5_a',
        serviceId: 'srv_sports_massage',
        serviceName: 'Sports & Muscle Recovery Therapy',
        userId: 'usr_kabir',
        userName: 'Kabir Mehta',
        rating: 4.9,
        comment:
            'As an avid half-marathoner, this post-race recovery therapy was a lifesaver. Hamstrings, calves and IT band tightness unlocked in 60 minutes.',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        isVerifiedBooking: true,
      ),
      ReviewModel(
        id: 'rev_5_b',
        serviceId: 'srv_sports_massage',
        serviceName: 'Sports & Muscle Recovery Therapy',
        userId: 'usr_aman',
        userName: 'Aman Gupta',
        rating: 5.0,
        comment:
            'Excellent cross-fiber friction and trigger point work. My range of motion improved immediately.',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        isVerifiedBooking: true,
      ),

      // 6. Relaxation Massage Reviews
      ReviewModel(
        id: 'rev_6_a',
        serviceId: 'srv_relaxation',
        serviceName: 'ZOVRA Signature Relaxation Therapy',
        userId: 'usr_neha',
        userName: 'Neha Kapoor',
        rating: 4.9,
        comment:
            'Calming, gentle, and zero rushing. The therapist was soft-spoken, confirmed pressure levels twice, and left the room spotless.',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        isVerifiedBooking: true,
      ),

      // 7. Head & Shoulder Massage Reviews
      ReviewModel(
        id: 'rev_7_a',
        serviceId: 'srv_head_shoulder',
        serviceName: 'Head, Neck & Shoulder Tension Relief',
        userId: 'usr_rahul',
        userName: 'Rahul Joshi',
        rating: 5.0,
        comment:
            'Relieved my 3-day screen fatigue headache in under 45 minutes. The occipital pressure release and temple circular rubs were heavenly.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isVerifiedBooking: true,
      ),

      // 8. Back & Neck Massage Reviews
      ReviewModel(
        id: 'rev_8_a',
        serviceId: 'srv_back_neck',
        serviceName: 'Targeted Back & Neck Therapy',
        userId: 'usr_sunita',
        userName: 'Sunita Rao',
        rating: 4.8,
        comment:
            'My chronic cervical tightness from long desk hours felt 90% better right after. Professional and respectful.',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        isVerifiedBooking: true,
      ),

      // 9. Foot Reflexology Reviews
      ReviewModel(
        id: 'rev_9_a',
        serviceId: 'srv_foot_reflexology',
        serviceName: 'Ancient Thai Foot Reflexology',
        userId: 'usr_tanvi',
        userName: 'Tanvi Patel',
        rating: 5.0,
        comment:
            'Plantar acupressure was spot on! Therapist began with a soothing warm herbal foot cleanse. My feet felt so light afterwards.',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        isVerifiedBooking: true,
      ),

      // 10. Couple Massage Reviews
      ReviewModel(
        id: 'rev_10_a',
        serviceId: 'srv_couple_massage',
        serviceName: 'Dual Harmony Couple Massage Experience',
        userId: 'usr_karan',
        userName: 'Karan & Shruti',
        rating: 5.0,
        comment:
            'Booked for our anniversary celebration. Two senior therapists arrived with synchronized music and dual beds. Felt like an exotic resort in the comfort of our living room!',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isVerifiedBooking: true,
      ),

      // 11. Spa Ritual Reviews
      ReviewModel(
        id: 'rev_11_a',
        serviceId: 'srv_spa_ritual',
        serviceName: 'Imperial 5-Star Holistic Spa Experience',
        userId: 'usr_malini',
        userName: 'Malini Iyer',
        rating: 5.0,
        comment:
            'The volcanic hot stone therapy and organic body scrub took this to an entirely different league. Worth every single rupee.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        isVerifiedBooking: true,
      ),
    ];
  }

  /// Sample demo bookings
  static List<BookingModel> getBookings() {
    final now = DateTime.now();
    final services = getServices();
    final dryMassage = services.firstWhere(
      (s) => s.id == 'srv_dry_massage',
      orElse: () => services.first,
    );
    final swedishMassage = services.firstWhere(
      (s) => s.id == 'srv_swedish_massage',
      orElse: () => services.length > 1 ? services[1] : services.first,
    );

    return [
      // 1. Upcoming Confirmed Booking
      BookingModel(
        id: 'ZOV-2026-891',
        userId: 'usr_guest',
        items: [
          CartItem(
            id: 'ci_demo_1',
            service: dryMassage,
            selectedPackage: dryMassage.packages.isNotEmpty ? dryMassage.packages[0] : null,
            quantity: 1,
          ),
        ],
        scheduledDate: now.add(const Duration(days: 1)),
        timeSlot: '11:00 AM - 12:30 PM',
        address: getAddresses().first,
        subtotal: 849,
        serviceDiscount: 350,
        couponDiscount: 0,
        taxAmount: 152.82,
        platformFee: 49,
        totalAmount: 1050.82,
        paymentMethod: 'UPI (Google Pay)',
        paymentStatus: 'Paid',
        status: BookingStatus.confirmed,
        partnerName: 'Vikram Singh',
        partnerPhone: '+91 98112 34567',
        partnerRating: 4.9,
        partnerAvatar: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80',
        createdAt: now.subtract(const Duration(hours: 3)),
        transactionId: 'TXN-UPI-9821734912',
      ),

      // 2. Verified Completed Booking
      BookingModel(
        id: 'ZOV-2026-754',
        userId: 'usr_guest',
        items: [
          CartItem(
            id: 'ci_demo_2',
            service: swedishMassage,
            selectedPackage: swedishMassage.packages.isNotEmpty ? swedishMassage.packages[0] : null,
            quantity: 1,
          ),
        ],
        scheduledDate: now.subtract(const Duration(days: 3)),
        timeSlot: '04:00 PM - 05:30 PM',
        address: getAddresses().first,
        subtotal: 1249,
        serviceDiscount: 450,
        couponDiscount: 200,
        couponCode: 'WELCOME20',
        taxAmount: 224.82,
        platformFee: 49,
        totalAmount: 1322.82,
        paymentMethod: 'UPI (Google Pay)',
        paymentStatus: 'Paid',
        status: BookingStatus.completed,
        partnerName: 'Priya Sharma',
        partnerPhone: '+91 98223 45678',
        partnerRating: 5.0,
        partnerAvatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=300&q=80',
        createdAt: now.subtract(const Duration(days: 4)),
        transactionId: 'TXN-UPI-7749102834',
      ),
    ];
  }

  static List<BookingModel> getInitialBookings() => getBookings();

  /// Initial notifications
  static List<NotificationItem> getNotifications() {
    return [
      NotificationItem(
        id: 'notif_welcome',
        title: 'Welcome to ZOVRA Wellness! 🌿',
        body: 'Use code WELCOME20 to get 20% OFF your first luxury home massage.',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
        type: 'offer',
      ),
    ];
  }

  /// Initial support tickets
  static List<SupportTicket> getSupportTickets() {
    return [];
  }

  static List<SupportTicket> getInitialSupportTickets() => getSupportTickets();
}
