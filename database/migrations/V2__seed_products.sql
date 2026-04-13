-- V2: Seed Product Data (100 products, ~180 SKUs)
-- Chewy-style North America Pet Supplies
-- Generated for Sprint 1 MVP

SET NAMES utf8mb4;

-- ============================================================
-- 分类数据
-- ============================================================
INSERT INTO categories (id, name, parent_id, slug, sort_order, status) VALUES
(1, 'Dog', 0, 'dog', 1, 1),
(2, 'Cat', 0, 'cat', 2, 1),
(3, 'Fish & Aquatic', 0, 'fish', 3, 1),
(4, 'Bird', 0, 'bird', 4, 1),
(5, 'Small Pet', 0, 'small-pet', 5, 1),
(6, 'Dog Food', 1, 'dog-food', 1, 1),
(7, 'Dog Treats', 1, 'dog-treats', 2, 1),
(8, 'Dog Toys', 1, 'dog-toys', 3, 1),
(9, 'Dog Health', 1, 'dog-health', 4, 1),
(10, 'Cat Food', 2, 'cat-food', 1, 1),
(11, 'Cat Treats', 2, 'cat-treats', 2, 1),
(12, 'Cat Litter', 2, 'cat-litter', 3, 1),
(13, 'Cat Health', 2, 'cat-health', 4, 1),
(14, 'Fish Food', 3, 'fish-food', 1, 1),
(15, 'Fish Tank & Accessories', 3, 'fish-tank', 2, 1),
(16, 'Bird Food', 4, 'bird-food', 1, 1),
(17, 'Bird Accessories', 4, 'bird-accessories', 2, 1),
(18, 'Small Pet Food', 5, 'small-pet-food', 1, 1),
(19, 'Small Pet Accessories', 5, 'small-pet-accessories', 2, 1);

-- ============================================================
-- Dog Products (30) - category_id: 6=Dog Food, 7=Dog Treats, 8=Dog Toys, 9=Dog Health
-- ============================================================
INSERT INTO products (id, category_id, spu_code, name, brand, description, price, sale_price, images, tags, autoship_eligible, status) VALUES
(1, 6, 'DOG-FOOD-001', 'Blue Buffalo Life Protection Formula Adult Dog Food, Chicken & Brown Rice Recipe, 30 lbs', 'Blue Buffalo', 'Made with real chicken as the first ingredient. Contains LifeSource Bits with antioxidants, vitamins and minerals. No corn, wheat, soy, chicken by-product meals, or artificial flavors.', 54.98, 49.48, '["https://img.chewy.com/is/image/catalog/54321_MAIN.jpg"]', '["dog", "dry-food", "chicken", "adult"]', 1, 1),
(2, 6, 'DOG-FOOD-002', 'Purina Pro Plan Adult Sensitive Skin & Stomach Salmon & Rice Formula Dry Dog Food, 30 lbs', 'Purina Pro Plan', 'Salmon is the #1 ingredient. Fortified with guaranteed live probiotics to support digestive and immune health. Oat meal is easily digestible and gentle on the digestive system.', 64.98, 58.48, '["https://img.chewy.com/is/image/catalog/54322_MAIN.jpg"]', '["dog", "dry-food", "salmon", "sensitive-stomach", "adult"]', 1, 1),
(3, 6, 'DOG-FOOD-003', 'Hill''s Science Diet Adult Large Breed Chicken & Barley Recipe Dry Dog Food, 35 lbs', 'Hill''s Science Diet', 'Clinically proven antioxidants for a healthy immune system. Optimal levels of omega-6 fatty acids and vitamin E nourish skin and coat. Glucosamine and chondroitin for joint health.', 72.99, 65.68, '["https://img.chewy.com/is/image/catalog/54323_MAIN.jpg"]', '["dog", "dry-food", "large-breed", "chicken", "adult"]', 1, 1),
(4, 6, 'DOG-FOOD-004', 'Royal Canin Size Health Nutrition Medium Adult Dry Dog Food, 30 lbs', 'Royal Canin', 'Precisely meets the needs of medium dogs 12 months to 7 years. Optimal stool quality with highly digestible proteins and balanced fiber. Maintains healthy weight with an adapted calorie content.', 68.99, 62.08, '["https://img.chewy.com/is/image/catalog/54324_MAIN.jpg"]', '["dog", "dry-food", "medium-breed", "adult"]', 1, 1),
(5, 6, 'DOG-FOOD-005', 'Orijen Original Grain-Free Dry Dog Food, 25 lbs', 'Orijen', 'Biologically appropriate with 85% quality animal ingredients. Features free-run chicken and turkey, wild-caught fish, and cage-free eggs. WholePrey ratios of meat, organs, and bone.', 89.99, 80.98, '["https://img.chewy.com/is/image/catalog/54325_MAIN.jpg"]', '["dog", "dry-food", "grain-free", "high-protein", "adult"]', 1, 1),
(6, 6, 'DOG-FOOD-006', 'Wellness CORE Grain-Free Original Deboned Turkey & Chicken Recipe Dry Dog Food, 26 lbs', 'Wellness', 'Grain-free, protein-focused nutrition. Turkey and chicken as first ingredients. Omega fatty acids for healthy skin and coat. Antioxidants for immune support.', 74.95, 67.45, '["https://img.chewy.com/is/image/catalog/54326_MAIN.jpg"]', '["dog", "dry-food", "grain-free", "turkey", "chicken"]', 1, 1),
(7, 6, 'DOG-FOOD-007', 'Taste of the Wild High Prairie Grain-Free Dry Dog Food, 28 lbs', 'Taste of the Wild', 'Real roasted bison and venison. Grain-free recipe with optimal amino acid profile to help support lean, strong muscles. Antioxidants from fruits and veggies help support a healthy immune system.', 57.99, 52.18, '["https://img.chewy.com/is/image/catalog/54327_MAIN.jpg"]', '["dog", "dry-food", "grain-free", "bison", "venison"]', 1, 1),
(8, 6, 'DOG-FOOD-008', 'Merrick Grain Free Real Beef & Sweet Potato Recipe Adult Dry Dog Food, 25 lbs', 'Merrick', 'Deboned beef is the #1 ingredient. Grain-free, gluten-free recipe for dogs with food sensitivities. High protein recipe helps build and maintain healthy lean muscle mass.', 62.98, 56.68, '["https://img.chewy.com/is/image/catalog/54328_MAIN.jpg"]', '["dog", "dry-food", "grain-free", "beef", "adult"]', 1, 1),
(9, 6, 'DOG-FOOD-009', 'Iams Proactive Health Adult MiniChunks Dry Dog Food, Chicken, 40 lbs', 'Iams', 'Real chicken as the #1 ingredient. Optimal protein from chicken helps maintain strong muscles. Contains 0% fillers. Antioxidant blend to help support a healthy immune system.', 44.98, 40.48, '["https://img.chewy.com/is/image/catalog/54329_MAIN.jpg"]', '["dog", "dry-food", "chicken", "adult", "value"]', 1, 1),
(10, 6, 'DOG-FOOD-010', 'Zignature Trout & Salmon Meal Formula Limited Ingredient Diet Grain-Free Dry Dog Food, 27 lbs', 'Zignature', 'Limited ingredient diet with trout and salmon meal. Grain, corn, wheat, soy, dairy and egg-free. Ideal for dogs with food allergies and sensitivities.', 79.99, 71.98, '["https://img.chewy.com/is/image/catalog/54330_MAIN.jpg"]', '["dog", "dry-food", "grain-free", "salmon", "trout", "limited-ingredient"]', 1, 1),
(11, 6, 'DOG-FOOD-011', 'Blue Buffalo Wilderness High Protein Grain Free Natural Puppy Dry Dog Food, Chicken, 24 lbs', 'Blue Buffalo', 'More of the chicken puppies crave. Supports brain and retinal development with DHA and ARA. Supports strong muscles with high protein. Grain free recipe with no chicken by-product meals.', 59.98, 53.98, '["https://img.chewy.com/is/image/catalog/54331_MAIN.jpg"]', '["dog", "dry-food", "puppy", "chicken", "grain-free", "high-protein"]', 1, 1),
(12, 6, 'DOG-FOOD-012', 'Purina Pro Plan Bright Mind Adult 7+ Chicken & Rice Formula Dry Dog Food, 34 lbs', 'Purina Pro Plan', 'With enhanced botanical oils shown to promote alertness and mental sharpness in dogs 7 and older. Contains 30% protein to help maintain lean muscle. Prebiotic fiber nourishes specific intestinal bacteria.', 78.98, 71.08, '["https://img.chewy.com/is/image/catalog/54332_MAIN.jpg"]', '["dog", "dry-food", "senior", "chicken", "senior-formula"]', 1, 1),
(13, 7, 'DOG-TREAT-001', 'Milk-Bone Original Dog Treats, Small, 24 oz', 'Milk-Bone', 'Crunchy biscuits your dog will love. Formulated with 12 vitamins and minerals. With calcium to support strong teeth and bones. The original dog treat since 1908.', 8.99, 8.09, '["https://img.chewy.com/is/image/catalog/54333_MAIN.jpg"]', '["dog", "treats", "biscuits", "classic"]', 1, 1),
(14, 7, 'DOG-TREAT-002', 'Blue Buffalo Blue Bits Soft-Moist Training Dog Treats, Turkey Recipe, 19 oz', 'Blue Buffalo', 'Made with real turkey. Grain-free, gluten-free recipe. Soft and chewy bites. No artificial flavors or preservatives. Contains LifeSource Bits.', 14.98, 13.48, '["https://img.chewy.com/is/image/catalog/54334_MAIN.jpg"]', '["dog", "treats", "soft", "training", "turkey"]', 1, 1),
(15, 7, 'DOG-TREAT-003', 'Zuke''s Mini Naturals Chicken Recipe Training Dog Treats, 16 oz', 'Zuke''s', 'Only 3 calories per treat. Real chicken is the #1 ingredient. Soft and chewy mini treats perfect for training. No corn, wheat, or soy.', 12.99, 11.69, '["https://img.chewy.com/is/image/catalog/54335_MAIN.jpg"]', '["dog", "treats", "training", "chicken", "mini"]', 1, 1),
(16, 7, 'DOG-TREAT-004', 'Wellness Soft WellBites Lamb & Salmon Recipe Dog Treats, 8 oz', 'Wellness', 'Made with deboned lamb and salmon. Grain-free and gluten-free. Made in the USA. No artificial flavors, colors, or preservatives.', 9.99, 8.99, '["https://img.chewy.com/is/image/catalog/54336_MAIN.jpg"]', '["dog", "treats", "soft", "lamb", "salmon", "grain-free"]', 1, 1),
(17, 7, 'DOG-TREAT-005', 'Merrick Power Bites Grain-Free Real Beef Recipe Soft & Chewy Dog Treats, 6 oz', 'Merrick', 'Deboned beef is the #1 ingredient. Grain-free and gluten-free. Made in the USA. Soft and chewy texture. No artificial colors or preservatives.', 8.99, 8.09, '["https://img.chewy.com/is/image/catalog/54337_MAIN.jpg"]', '["dog", "treats", "soft", "beef", "grain-free"]', 1, 1),
(18, 8, 'DOG-TOY-001', 'KONG Classic Dog Toy, Large', 'KONG', 'Made of natural rubber. Durable chew toy for powerful chewers. Stuffable with kibble, treats or KONG Easy Treat. Erratic bounce keeps dogs engaged. Dishwasher safe.', 13.99, 12.59, '["https://img.chewy.com/is/image/catalog/54338_MAIN.jpg"]', '["dog", "toy", "chew", "rubber", "interactive"]', 0, 1),
(19, 8, 'DOG-TOY-002', 'Chuckit! Ultra Ball Dog Toy, Large, 2-pack', 'Chuckit!', 'High bounce ultra rubber ball. Durable and floats in water. Compatible with all Chuckit! ball launchers. Bright color for high visibility. Easy to pick up.', 12.99, 11.69, '["https://img.chewy.com/is/image/catalog/54339_MAIN.jpg"]', '["dog", "toy", "ball", "fetch", "outdoor"]', 0, 1),
(20, 8, 'DOG-TOY-003', 'Outward Hound Hide-A-Squirrel Puzzle Plush Dog Toy, Large, 5-piece', 'Outward Hound', 'Interactive hide-and-seek toy. Includes log and 4 squeaky squirrels. Great for natural hunting and foraging instincts. Machine washable.', 19.99, 17.99, '["https://img.chewy.com/is/image/catalog/54340_MAIN.jpg"]', '["dog", "toy", "plush", "interactive", "puzzle"]', 0, 1),
(21, 8, 'DOG-TOY-004', 'Nylabone Dura Chew Textured Dog Chew Toy, Chicken Flavor, Large', 'Nylabone', 'Made of durable nylon material. Chicken flavoring. Textured ridges and nubs help clean teeth. Long-lasting chew. Suitable for aggressive chewers.', 10.99, 9.89, '["https://img.chewy.com/is/image/catalog/54341_MAIN.jpg"]', '["dog", "toy", "chew", "nylon", "dental"]', 0, 1),
(22, 8, 'DOG-TOY-005', 'Frisco Rope Braid Tug Dog Toy, 26-in', 'Frisco', 'Triple-knotted rope toy for tug-of-war play. Durable cotton blend. Great for interactive play and tug. Helps clean teeth and massage gums. Bright multi-color design.', 9.99, 8.99, '["https://img.chewy.com/is/image/catalog/54342_MAIN.jpg"]', '["dog", "toy", "rope", "tug", "interactive"]', 0, 1),
(23, 9, 'DOG-HEALTH-001', 'Frontline Plus Flea & Tick Treatment for Dogs, 45-88 lbs, 6 doses', 'Frontline Plus', 'Kills fleas, flea eggs, flea larvae, chewing lice and ticks including those that may transmit Lyme disease. Waterproof formula. Easy-to-apply topical treatment. Lasts 30 days.', 59.99, 53.99, '["https://img.chewy.com/is/image/catalog/54343_MAIN.jpg"]', '["dog", "health", "flea-tick", "topical", "prevention"]', 1, 1),
(24, 9, 'DOG-HEALTH-002', 'NexGard Flea & Tick Chew for Dogs, 60.1-121 lbs, 6 doses', 'NexGard', 'Beef-flavored chewable. FDA-approved to prevent Lyme disease. Kills fleas and ticks for 30 days. The #1 vet-recommended flea and tick brand. Safe for dogs 8 weeks and older.', 119.99, 107.98, '["https://img.chewy.com/is/image/catalog/54344_MAIN.jpg"]', '["dog", "health", "flea-tick", "oral", "chewable"]', 1, 1),
(25, 9, 'DOG-HEALTH-003', 'Cosequin DS Maximum Strength Joint Health Supplement for Dogs, 132-count', 'Cosequin', 'Contains glucosamine and chondroitin. Helps support and protect dog joints. Available without prescription. Safe for long-term use. #1 veterinarian recommended joint health supplement.', 34.98, 31.48, '["https://img.chewy.com/is/image/catalog/54345_MAIN.jpg"]', '["dog", "health", "joint", "supplement", "glucosamine"]', 1, 1),
(26, 9, 'DOG-HEALTH-004', 'Purina Pro Plan Veterinary Supplements FortiFlora Dog Probiotic Supplement, 30-count', 'Purina Pro Plan', 'Contains a guaranteed amount of live active cultures. Promotes intestinal microflora balance. Promotes a healthy immune system. #1 probiotic brand recommended by veterinarians.', 29.98, 26.98, '["https://img.chewy.com/is/image/catalog/54346_MAIN.jpg"]', '["dog", "health", "probiotic", "supplement", "digestive"]', 1, 1),
(27, 9, 'DOG-HEALTH-005', 'Ruffwear Front Range Dog Harness, Red Sumac, Medium', 'Ruffwear', 'Two leash attachment points - reinforced aluminum V-ring on back and load-dispersing chest V-ring. Padded chest and belly panels. ID pocket and reflective trim. Four adjustment points.', 39.95, 35.95, '["https://img.chewy.com/is/image/catalog/54347_MAIN.jpg"]', '["dog", "harness", "walking", "no-pull"]', 0, 1),
(28, 9, 'DOG-HEALTH-006', 'Flexi New Classic Retractable Dog Leash, 16 ft, Medium', 'Flexi', 'Up to 16 feet of freedom. Retractable tape line. Ergonomic non-slip handle. Brake and lock button. Weight limit 44 lbs. Reflective elements for visibility.', 19.99, 17.99, '["https://img.chewy.com/is/image/catalog/54348_MAIN.jpg"]', '["dog", "leash", "retractable", "walking"]', 0, 1),
(29, 6, 'DOG-FOOD-013', 'Blue Buffalo Basics Limited Ingredient Diet Grain Free Adult Dog Food, Turkey & Potato, 22 lbs', 'Blue Buffalo', 'A single animal protein source - real turkey. Grain-free, pea-free formula. No chicken, beef, corn, wheat, soy, dairy or eggs. Contains LifeSource Bits for immune support.', 59.98, 53.98, '["https://img.chewy.com/is/image/catalog/54349_MAIN.jpg"]', '["dog", "dry-food", "limited-ingredient", "turkey", "grain-free"]', 1, 1),
(30, 8, 'DOG-TOY-006', 'West Paw Zogoflex Hurley Dog Bone Chew Toy, Granny Smith, Large', 'West Paw', 'Non-toxic. Dishwasher safe. Recyclable. Floats in water. Guaranteed tough. Made in USA. BPA and phthalate free.', 14.95, 13.45, '["https://img.chewy.com/is/image/catalog/54350_MAIN.jpg"]', '["dog", "toy", "chew", "durable", "eco-friendly"]', 0, 1);


-- ============================================================
-- Cat Products (30) - category_id: 10=Cat Food, 11=Cat Treats, 12=Cat Litter, 13=Cat Health
-- ============================================================
INSERT INTO products (id, category_id, spu_code, name, brand, description, price, sale_price, images, tags, autoship_eligible, status) VALUES
(31, 10, 'CAT-FOOD-001', 'Blue Buffalo Indoor Health Adult Dry Cat Food, Chicken & Brown Rice, 15 lbs', 'Blue Buffalo', 'Made with real chicken. Deboned chicken is the first ingredient. Contains LifeSource Bits with antioxidants, vitamins and minerals. For indoor cats. Hairball control formula.', 34.98, 31.48, '["https://img.chewy.com/is/image/catalog/54351_MAIN.jpg"]', '["cat", "dry-food", "chicken", "indoor", "adult"]', 1, 1),
(32, 10, 'CAT-FOOD-002', 'Purina Pro Plan Adult Sensitive Skin & Stomach Salmon & Rice Formula Dry Cat Food, 16 lbs', 'Purina Pro Plan', 'Salmon is the #1 ingredient. Fortified with live probiotics to support digestive health. Omega-6 fatty acids and vitamin A nourish skin and coat. No artificial colors, flavors or preservatives.', 37.98, 34.18, '["https://img.chewy.com/is/image/catalog/54352_MAIN.jpg"]', '["cat", "dry-food", "salmon", "sensitive", "adult"]', 1, 1),
(33, 10, 'CAT-FOOD-003', 'Hill''s Science Diet Adult Indoor Cat Dry Cat Food, Chicken Recipe, 15.5 lbs', 'Hill''s Science Diet', 'Clinically proven antioxidants for a healthy immune system. Controlled minerals to support urinary health. Easy to digest formula with natural fibers for hairball control. Real chicken.', 39.99, 35.99, '["https://img.chewy.com/is/image/catalog/54353_MAIN.jpg"]', '["cat", "dry-food", "chicken", "indoor", "hairball"]', 1, 1),
(34, 10, 'CAT-FOOD-004', 'Royal Canin Feline Health Nutrition Indoor Adult Dry Cat Food, 15 lbs', 'Royal Canin', 'Precise nutrition for indoor cats 1 to 7 years. Optimal digestive health with highly digestible proteins and balanced fiber. Helps neutralize odors for reduced stool and body odors. Hairball elimination.', 42.99, 38.68, '["https://img.chewy.com/is/image/catalog/54354_MAIN.jpg"]', '["cat", "dry-food", "indoor", "adult", "hairball"]', 1, 1),
(35, 10, 'CAT-FOOD-005', 'Orijen Cat & Kitten Grain-Free Dry Cat Food, 10 lbs', 'Orijen', 'Biologically appropriate with 90% quality animal ingredients. Features free-run chicken and turkey, wild-caught fish, and cage-free eggs. WholePrey ratios of meat, organs, and cartilage.', 49.99, 44.98, '["https://img.chewy.com/is/image/catalog/54355_MAIN.jpg"]', '["cat", "dry-food", "grain-free", "kitten", "high-protein"]', 1, 1),
(36, 10, 'CAT-FOOD-006', 'Wellness CORE Grain-Free Original Chicken & Turkey Recipe Dry Cat Food, 11 lbs', 'Wellness', 'Grain-free, protein-focused nutrition. Deboned chicken and turkey as first ingredients. Omega fatty acids for healthy skin and coat. Taurine for healthy heart and eyes.', 32.95, 29.65, '["https://img.chewy.com/is/image/catalog/54356_MAIN.jpg"]', '["cat", "dry-food", "grain-free", "chicken", "turkey"]', 1, 1),
(37, 10, 'CAT-FOOD-007', 'Purina Fancy Feast Gravy Lovers Variety Pack Wet Cat Food, 3 oz, 24-count', 'Fancy Feast', 'A variety of gourmet flavors in savory gravy. No artificial flavors or preservatives. 100% complete and balanced for adult cats. Real poultry or seafood as the first ingredient.', 21.98, 19.78, '["https://img.chewy.com/is/image/catalog/54357_MAIN.jpg"]', '["cat", "wet-food", "variety", "gravy", "adult"]', 1, 1),
(38, 10, 'CAT-FOOD-008', 'Wellness Complete Health Turkey & Salmon Formula Grain-Free Canned Cat Food, 12.5 oz, 12-count', 'Wellness', 'No meat by-products, wheat, corn or soy. No artificial colors, flavors or preservatives. Contains added vitamins and minerals. Grain-free formula. Turkey and salmon for taste and nutrition.', 29.88, 26.88, '["https://img.chewy.com/is/image/catalog/54358_MAIN.jpg"]', '["cat", "wet-food", "grain-free", "turkey", "salmon"]', 1, 1),
(39, 10, 'CAT-FOOD-009', 'Hill''s Science Diet Kitten Dry Cat Food, Chicken Recipe, 7 lbs', 'Hill''s Science Diet', 'DHA from fish oil for brain and eye development. Clinically proven antioxidants support a healthy immune system. High quality protein for building and maintaining lean muscle. Crafted with natural ingredients.', 22.99, 20.68, '["https://img.chewy.com/is/image/catalog/54359_MAIN.jpg"]', '["cat", "dry-food", "kitten", "chicken", "dha"]', 1, 1),
(40, 10, 'CAT-FOOD-010', 'Merrick Purrfect Bistro Grain Free Chicken Pate Canned Cat Food, 5.5 oz, 24-count', 'Merrick', 'Deboned chicken as the #1 ingredient. Grain-free, gluten-free recipe. Made in the USA. Pate texture cats love. No artificial colors, flavors or preservatives.', 34.80, 31.32, '["https://img.chewy.com/is/image/catalog/54360_MAIN.jpg"]', '["cat", "wet-food", "grain-free", "chicken", "pate"]', 1, 1),
(41, 10, 'CAT-FOOD-011', 'Blue Buffalo Tastefuls Natural Pate Wet Cat Food, Chicken Entree, 3 oz, 24-count', 'Blue Buffalo', 'Real deboned chicken as the #1 ingredient. No chicken by-products, corn, wheat, soy or artificial flavors and preservatives. Creamy pate texture. Essential vitamins, minerals and antioxidants.', 22.80, 20.52, '["https://img.chewy.com/is/image/catalog/54361_MAIN.jpg"]', '["cat", "wet-food", "chicken", "pate", "adult"]', 1, 1),
(42, 10, 'CAT-FOOD-012', 'Royal Canin Persian Adult Breed Specific Dry Cat Food, 7 lbs', 'Royal Canin', 'Exclusive almond-shaped kibble designed for Persian cats to pick up easily. Skin barrier support with essential fatty acids and key nutrients. Supports digestive health and coat quality.', 29.99, 26.98, '["https://img.chewy.com/is/image/catalog/54362_MAIN.jpg"]', '["cat", "dry-food", "persian", "breed-specific", "adult"]', 1, 1),
(43, 11, 'CAT-TREAT-001', 'Temptations Classic Crunchy and Soft Cat Treats, Tasty Chicken Flavor, 30 oz', 'Temptations', 'Crunchy outside, soft inside. Less than 2 calories per treat. Cats go crazy for Temptations. No artificial flavors. Made with real chicken. 100% nutritionally complete and balanced.', 12.98, 11.68, '["https://img.chewy.com/is/image/catalog/54363_MAIN.jpg"]', '["cat", "treats", "chicken", "crunchy", "soft"]', 1, 1),
(44, 11, 'CAT-TREAT-002', 'Churu Cat Treats by INABA, Chicken Variety, Lickable Creamy Puree Cat Treats, 50-count', 'INABA', 'Silky-smooth puree treats. Made with real chicken and tuna. High moisture content. No grains, fillers or artificial preservatives. Great for bonding. Can be used as a meal topper.', 19.99, 17.98, '["https://img.chewy.com/is/image/catalog/54364_MAIN.jpg"]', '["cat", "treats", "lickable", "puree", "chicken", "tuna"]', 1, 1),
(45, 11, 'CAT-TREAT-003', 'Wellness Kittles Grain-Free Salmon & Cranberries Recipe Crunchy Cat Treats, 2 oz', 'Wellness', 'Salmon as the #1 ingredient. Grain-free and gluten-free. Crunchy texture cats love. With real cranberries. No corn, wheat, or soy. Made with natural ingredients.', 4.49, 4.04, '["https://img.chewy.com/is/image/catalog/54365_MAIN.jpg"]', '["cat", "treats", "crunchy", "salmon", "grain-free"]', 1, 1),
(46, 12, 'CAT-LITTER-001', 'Fresh Step Advanced Clumping Cat Litter with Febreze Freshness, Scented, 37 lbs', 'Fresh Step', 'Advanced clumping for tight clumps that lock away odors. Febreze Freshness technology continuously eliminates odors. Low-tracking formula. Paw-activated carbon blocks odors.', 29.99, 26.98, '["https://img.chewy.com/is/image/catalog/54366_MAIN.jpg"]', '["cat", "litter", "clumping", "scented", "odor-control"]', 1, 1),
(47, 12, 'CAT-LITTER-002', 'Dr. Elsey''s Ultra Unscented Clumping Clay Cat Litter, 40 lbs', 'Dr. Elsey''s', 'Heavy duty clumping formula. Superior clumping to keep moisture away from the bottom of the litter box. Hypoallergenic. 99.9% dust free. Hard clumping prevents moisture from reaching the bottom.', 27.99, 25.19, '["https://img.chewy.com/is/image/catalog/54367_MAIN.jpg"]', '["cat", "litter", "clumping", "unscented", "dust-free"]', 1, 1),
(48, 12, 'CAT-LITTER-003', 'Tidy Cats Lightweight 24/7 Performance Clumping Cat Litter, 17 lbs', 'Tidy Cats', 'Half the weight of regular clumping litter. Powerful Tidy Lock Protection to lock in odors. Makes clean up easy. Outstanding 10-day odor control. For multi-cat households.', 25.98, 23.38, '["https://img.chewy.com/is/image/catalog/54368_MAIN.jpg"]', '["cat", "litter", "lightweight", "clumping", "multi-cat"]', 1, 1),
(49, 12, 'CAT-LITTER-004', 'World''s Best Cat Litter Original Unscented, 28 lbs', 'World''s Best Cat Litter', 'Made from concentrated corn. Outclasses clay litters. Flushable and septic safe. Safe for cats, people and the planet. Outstanding odor control. Quick clumping formula.', 33.99, 30.58, '["https://img.chewy.com/is/image/catalog/54369_MAIN.jpg"]', '["cat", "litter", "natural", "flushable", "corn", "unscented"]', 1, 1),
(50, 12, 'CAT-LITTER-005', 'Arm & Hammer Slide Easy Clean-Up Clumping Litter, Multi-Cat, 28 lbs', 'Arm & Hammer', 'Clumps slide right out. Baking soda destroys odors. Hard-clumping formula. 14-day odor control guarantee. Low dust formula. For multi-cat households.', 24.98, 22.48, '["https://img.chewy.com/is/image/catalog/54370_MAIN.jpg"]', '["cat", "litter", "clumping", "multi-cat", "baking-soda"]', 1, 1),
(51, 13, 'CAT-HEALTH-001', 'Feliway Classic Cat Calming Diffuser Kit, 30 day starter kit', 'Feliway', 'Drug-free solution for cat stress and anxiety. Mimics cat natural calming pheromones. Helps stop unwanted behaviors. Covers up to 700 sq ft. For indoor use. Vet recommended.', 29.99, 26.98, '["https://img.chewy.com/is/image/catalog/54371_MAIN.jpg"]', '["cat", "health", "calming", "pheromone", "behavior"]', 1, 1),
(52, 13, 'CAT-HEALTH-002', 'Revolution Plus Topical Solution for Cats, 2.8-5.5 lbs, 6 doses', 'Revolution Plus', 'Kills fleas and prevents flea eggs from hatching. Kills ticks and ear mites. Prevents heartworm disease. Treats and controls roundworms and hookworms. Waterproof formula.', 89.99, 80.98, '["https://img.chewy.com/is/image/catalog/54372_MAIN.jpg"]', '["cat", "health", "flea-tick", "parasite", "prevention"]', 1, 1),
(53, 13, 'CAT-HEALTH-003', 'Nutri-Vet Hairball Support Soft Chews for Cats, Chicken Flavor, 5.3 oz', 'Nutri-Vet', 'Helps prevent and eliminate hairballs. Supported by omega fatty acids to promote healthy skin and coat. Chicken liver flavor cats love. Made in the USA. Soft chew format.', 7.99, 7.19, '["https://img.chewy.com/is/image/catalog/54373_MAIN.jpg"]', '["cat", "health", "hairball", "supplement", "soft-chew"]', 1, 1),
(54, 13, 'CAT-HEALTH-004', 'SmartCat Pioneer Pet Ultimate Scratching Post', 'SmartCat', 'Stands 32 inches tall - tall enough for a full body stretch. Tightly woven sisal fiber. Very durable base for stability. Cats prefer sisal over carpet. Satisfaction guaranteed.', 29.99, 26.98, '["https://img.chewy.com/is/image/catalog/54374_MAIN.jpg"]', '["cat", "scratcher", "sisal", "post", "furniture-protection"]', 0, 1),
(55, 13, 'CAT-HEALTH-005', 'Frisco 72-in Faux Fur Cat Tree & Condo, Gray', 'Frisco', 'Features multiple levels, platforms, condos and sisal posts. Soft plush material for comfort. Provides scratching surfaces and lounging spots. Sturdy construction for stability.', 79.99, 71.98, '["https://img.chewy.com/is/image/catalog/54375_MAIN.jpg"]', '["cat", "cat-tree", "scratcher", "condo", "multi-level"]', 0, 1),
(56, 13, 'CAT-HEALTH-006', 'Bergan Turbo Scratcher Cat Toy & Scratching Pad', 'Bergan', 'Interactive ball track toy with scratcher. Ball spins around track to encourage play. Replaceable corrugated cardboard scratcher. Catnip included. Provides hours of entertainment.', 14.99, 13.49, '["https://img.chewy.com/is/image/catalog/54376_MAIN.jpg"]', '["cat", "toy", "scratcher", "interactive", "catnip"]', 0, 1),
(57, 11, 'CAT-TREAT-004', 'Greenies Feline Adult Natural Dental Care Cat Treats, Tempting Tuna Flavor, 5.5 oz', 'Greenies', 'Cleans teeth and freshens breath. Helps fight plaque and tartar buildup. Crunchy texture cats love. Made with natural ingredients plus vitamins, minerals and antioxidants. Vet recommended.', 8.99, 8.09, '["https://img.chewy.com/is/image/catalog/54377_MAIN.jpg"]', '["cat", "treats", "dental", "tuna", "oral-health"]', 1, 1),
(58, 10, 'CAT-FOOD-013', 'Iams Perfect Portions Grain-Free Signature Broths Wet Cat Food, Chicken, 1.3 oz, 24-count', 'Iams', 'Real chicken as the #1 ingredient. Grain-free formula. Rich in protein to maintain strong muscles. Made with real broths for incredible taste. Individual portion-controlled trays.', 19.99, 17.98, '["https://img.chewy.com/is/image/catalog/54378_MAIN.jpg"]', '["cat", "wet-food", "grain-free", "chicken", "broth"]', 1, 1),
(59, 13, 'CAT-HEALTH-007', 'SmartyKat Hot Pursuit Electronic Concealed Motion Cat Toy', 'SmartyKat', 'Electronic concealed motion toy. Spinning wand hides under fabric cover. Variable speed settings. On/off switch with auto shut-off. Stimulates natural hunting instincts.', 11.99, 10.79, '["https://img.chewy.com/is/image/catalog/54379_MAIN.jpg"]', '["cat", "toy", "electronic", "interactive", "hunting"]', 0, 1),
(60, 13, 'CAT-HEALTH-008', 'Catit Flower Fountain 3L Cat Water Fountain', 'Catit', '3-liter capacity. Triple action filter removes bad tastes, odors and debris. Flower top creates water streams. Encourages cats to drink more water. Quiet pump. Easy to clean.', 26.99, 24.28, '["https://img.chewy.com/is/image/catalog/54380_MAIN.jpg"]', '["cat", "water-fountain", "hydration", "health"]', 0, 1);


-- ============================================================
-- Fish Products (15) - category_id: 14=Fish Food, 15=Fish Tank & Accessories
-- ============================================================
INSERT INTO products (id, category_id, spu_code, name, brand, description, price, sale_price, images, tags, autoship_eligible, status) VALUES
(61, 14, 'FISH-FOOD-001', 'Fluval Bug Bites Tropical Fish Food Granules, 1.59 oz', 'Fluval', 'Made with up to 40% black soldier fly larvae - a natural fish protein. Contains salmon for Omega 3 & 6. Multiple proteins, vitamins and minerals. Slowly sinking granules for mid-level and bottom feeders.', 9.99, 8.99, '["https://img.chewy.com/is/image/catalog/54381_MAIN.jpg"]', '["fish", "fish-food", "tropical", "granules", "protein"]', 1, 1),
(62, 14, 'FISH-FOOD-002', 'Tetra TetraMin Tropical Flakes Fish Food, 7.06 oz', 'Tetra', 'Nutritionally balanced diet for tropical fish. ProCare blend for health and longevity. Clear water formula. Enhances fish colors. Easily digestible. For small to medium tropical fish.', 8.99, 8.09, '["https://img.chewy.com/is/image/catalog/54382_MAIN.jpg"]', '["fish", "fish-food", "tropical", "flakes", "color-enhancing"]', 1, 1),
(63, 14, 'FISH-FOOD-003', 'Hikari Sinking Carnivore Pellets for Pets Fish Food, 2.01 oz', 'Hikari', 'For carnivorous fish. Sinking pellets. Highly digestible. Ideal for loaches, catfish and other bottom feeders. Rich in vitamins and minerals. Reduces waste output.', 6.99, 6.29, '["https://img.chewy.com/is/image/catalog/54383_MAIN.jpg"]', '["fish", "fish-food", "carnivore", "pellets", "sinking"]', 1, 1),
(64, 14, 'FISH-FOOD-004', 'Omega One Color Mini Pellets Fish Food, 3.5 oz', 'Omega One', 'Natural color enhancing with beta carotenes. Fresh Alaska Seafood as first ingredient. Omega 3 & 6 fatty acids. Naturally insoluble - reduces water pollution. No binders or fillers.', 10.49, 9.44, '["https://img.chewy.com/is/image/catalog/54384_MAIN.jpg"]', '["fish", "fish-food", "color-enhancing", "pellets", "omega-3"]', 1, 1),
(65, 14, 'FISH-FOOD-005', 'San Francisco Bay Brand Freeze-Dried Bloodworms Fish Food, 0.5 oz', 'San Francisco Bay', 'Freeze-dried bloodworms. High protein treat for tropical and marine fish. Enhances color and conditioning. Ideal for bettas, tetras, gouramis and other tropical fish. No artificial additives.', 5.99, 5.39, '["https://img.chewy.com/is/image/catalog/54385_MAIN.jpg"]', '["fish", "fish-food", "freeze-dried", "bloodworms", "treat"]', 1, 1),
(66, 15, 'FISH-TANK-001', 'AquaClear 50 Power Filter for Aquariums up to 50 Gallons', 'AquaClear', 'Re-filtration system for maximum water clarity. Unique multi-stage filtration. Adjustable flow rate from 100-200 GPH. Separate filter media for mechanical, chemical and biological filtration. Energy efficient.', 49.99, 44.98, '["https://img.chewy.com/is/image/catalog/54386_MAIN.jpg"]', '["fish", "filter", "aquarium", "power-filter", "50-gallon"]', 0, 1),
(67, 15, 'FISH-TANK-002', 'Fluval 306 External Canister Filter for Aquariums up to 70 Gallons', 'Fluval', 'Powerful 3-stage filtration. Quiet motor technology. Priming system for quick startup. Ribbed hosing for flexible placement. Telescopic strainer. Oversized media baskets.', 114.99, 103.48, '["https://img.chewy.com/is/image/catalog/54387_MAIN.jpg"]', '["fish", "filter", "canister", "aquarium", "70-gallon"]', 0, 1),
(68, 15, 'FISH-TANK-003', 'Fluval Plant and Shrimp Stratum Aquarium Substrate, 4.4 lbs', 'Fluval', 'Ideal substrate for planted aquariums. Encourages healthy root growth. Stimulates plant growth. Promotes rapid colonization of nitrifying bacteria. Maintains slightly acidic pH favorable for plants.', 16.99, 15.28, '["https://img.chewy.com/is/image/catalog/54388_MAIN.jpg"]', '["fish", "substrate", "planted-tank", "shrimp", "aquarium"]', 0, 1),
(69, 15, 'FISH-TANK-004', 'API Freshwater Master Test Kit, 800-Test', 'API', 'Accurately monitor 5 most vital water parameters: pH, High Range pH, Ammonia, Nitrite and Nitrate. 800 tests per kit. Helps prevent invisible water problems that can be harmful to fish.', 34.99, 31.48, '["https://img.chewy.com/is/image/catalog/54389_MAIN.jpg"]', '["fish", "water-test", "freshwater", "chemistry", "aquarium"]', 1, 1),
(70, 15, 'FISH-TANK-005', 'Seachem Prime Fresh and Saltwater Conditioner, 500 mL', 'Seachem', 'Concentrated dechlorinator. Removes chlorine, chloramine and ammonia. Detoxifies nitrite and nitrate. Promotes slime coat. 5mL per 200 gallons. For fresh and salt water.', 14.49, 13.04, '["https://img.chewy.com/is/image/catalog/54390_MAIN.jpg"]', '["fish", "water-conditioner", "dechlorinator", "freshwater", "saltwater"]', 1, 1),
(71, 15, 'FISH-TANK-006', 'PETCO Brand - Imagitarium Brooklyn 6.8-Gallon Aquarium Kit', 'Imagitarium', 'Complete starter kit. Includes filter, LED lighting, net and fish food sample. 6.8-gallon capacity. Low-iron glass for better clarity. Sleek modern design. Great starter aquarium.', 59.99, 53.99, '["https://img.chewy.com/is/image/catalog/54391_MAIN.jpg"]', '["fish", "aquarium", "starter-kit", "led", "6-gallon"]', 0, 1),
(72, 15, 'FISH-TANK-007', 'Zoo Med Laboratories Floating Betta Log', 'Zoo Med', 'Natural cork-like appearance. Hollow inside for betta to rest, hide and breed. Floats at surface level where bettas prefer to rest. Durable resin material. 4 inches long.', 7.99, 7.19, '["https://img.chewy.com/is/image/catalog/54392_MAIN.jpg"]', '["fish", "decoration", "betta", "hide", "floating"]', 0, 1),
(73, 15, 'FISH-TANK-008', 'Imagitarium White Aquarium Gravel, 20 lbs', 'Imagitarium', 'Natural river gravel. Washed and ready for use. Non-toxic coating. For freshwater and marine aquariums. Promotes beneficial bacteria growth. Attractive natural look.', 12.99, 11.69, '["https://img.chewy.com/is/image/catalog/54393_MAIN.jpg"]', '["fish", "gravel", "substrate", "decoration", "freshwater"]', 0, 1),
(74, 14, 'FISH-FOOD-006', 'Wardley Goldfish Flake Food, 4.1 oz', 'Wardley', 'Specially formulated for goldfish and other cold water fish. Provides proteins and nutrients for healthy growth. Highly digestible formula reduces waste. Enhances brilliant coloration.', 4.99, 4.49, '["https://img.chewy.com/is/image/catalog/54394_MAIN.jpg"]', '["fish", "fish-food", "goldfish", "flakes", "cold-water"]', 1, 1),
(75, 15, 'FISH-TANK-009', 'Tetra Whisper IQ Power Filter for Aquariums, 30 Gallons', 'Tetra', 'Ultra-quiet Stay Clean technology. Self-priming. Minimal maintenance needed. Patented sound shield. Dense filter cartridge traps micro-particles. For aquariums up to 30 gallons.', 27.99, 25.18, '["https://img.chewy.com/is/image/catalog/54395_MAIN.jpg"]', '["fish", "filter", "quiet", "power-filter", "30-gallon"]', 0, 1);


-- ============================================================
-- Bird Products (15) - category_id: 16=Bird Food, 17=Bird Accessories
-- ============================================================
INSERT INTO products (id, category_id, spu_code, name, brand, description, price, sale_price, images, tags, autoship_eligible, status) VALUES
(76, 16, 'BIRD-FOOD-001', 'Kaytee Supreme Bird Seed Daily Blend, Canary & Finch, 2 lbs', 'Kaytee', 'High quality seed blend. Formulated for canaries and finches. Contains canary grass seeds, white millet, red millet and flax seeds. Naturally preserved freshness.', 5.99, 5.39, '["https://img.chewy.com/is/image/catalog/54396_MAIN.jpg"]', '["bird", "bird-food", "canary", "finch", "seed-blend"]', 1, 1),
(77, 16, 'BIRD-FOOD-002', 'ZuPreem FruitBlend Flavor Pellets Bird Food for Medium Birds, 2.25 lbs', 'ZuPreem', 'Fruit flavor pellets for cockatiels, quakers, small conures and lovebirds. Made with natural ingredients. Vitamins, minerals and amino acids baked right in. Highly digestible. No artificial preservatives.', 12.99, 11.69, '["https://img.chewy.com/is/image/catalog/54397_MAIN.jpg"]', '["bird", "bird-food", "pellets", "cockatiel", "fruit-blend"]', 1, 1),
(78, 16, 'BIRD-FOOD-003', 'Harrison''s Adult Lifetime Fine Organic Bird Food, 1 lb', 'Harrison''s', 'Certified organic ingredients. Complete nutrition for small birds. No artificial colors, flavors or preservatives. Formulated by avian veterinarians. USDA certified organic.', 17.99, 16.18, '["https://img.chewy.com/is/image/catalog/54398_MAIN.jpg"]', '["bird", "bird-food", "organic", "pellets", "small-birds"]', 1, 1),
(79, 16, 'BIRD-FOOD-004', 'Lafeber Classic Nutri-Berries Pet Bird Food for Parakeets, 10 oz', 'Lafeber', 'Balanced diet for parakeets. Berry-shaped nuggets with seeds, grains and pellets. Foraging enrichment opportunity. Contains whole canola seeds, peas and corn for foraging stimulation.', 8.99, 8.09, '["https://img.chewy.com/is/image/catalog/54399_MAIN.jpg"]', '["bird", "bird-food", "parakeet", "nutri-berries", "foraging"]', 1, 1),
(80, 16, 'BIRD-FOOD-005', 'Wild Harvest Advanced Nutrition Diet Parakeet Food, 2 lbs', 'Wild Harvest', 'Complete nutrition diet for parakeets. Contains canary grass seeds, millet and oat groats. Fortified with 21 vitamins and minerals. No artificial colors or flavors. With DHA Omega-3.', 7.49, 6.74, '["https://img.chewy.com/is/image/catalog/54400_MAIN.jpg"]', '["bird", "bird-food", "parakeet", "fortified", "vitamins"]', 1, 1),
(81, 16, 'BIRD-FOOD-006', 'Kaytee Fiesta Parrot Food, 4.5 lbs', 'Kaytee', 'Gourmet variety diet for large parrots. Provides foraging opportunities. Contains fruits, vegetables and a variety of seeds and grains. Fortified with vitamins and minerals. Supports immune system.', 16.99, 15.28, '["https://img.chewy.com/is/image/catalog/54401_MAIN.jpg"]', '["bird", "bird-food", "parrot", "variety", "large-bird"]', 1, 1),
(82, 17, 'BIRD-ACC-001', 'Prevue Pet Products Wrought Iron Flight Cage, 37x24x52 in', 'Prevue Pet Products', 'Spacious flight cage for canaries, finches and small birds. Wrought iron construction. 4 perches included. 3 doors. 2 feeder cups and 2 plastic cups. Safety lock doors. Rolling stand included.', 149.99, 134.98, '["https://img.chewy.com/is/image/catalog/54402_MAIN.jpg"]', '["bird", "cage", "flight-cage", "canary", "finch"]', 0, 1),
(83, 17, 'BIRD-ACC-002', 'Vision Bird Cage Model L01 Large, 30.3x18x54 in', 'Vision', 'Wire mesh to prevent food and seed scatter. Deep base prevents debris from falling out. Slide-out grille and tray for easy cleaning. Nesting perch included. Heavy-duty construction.', 119.99, 107.98, '["https://img.chewy.com/is/image/catalog/54403_MAIN.jpg"]', '["bird", "cage", "large", "easy-clean", "parakeet"]', 0, 1),
(84, 17, 'BIRD-ACC-003', 'Prevue Pet Products Naturals Rope Boing Bird Toy', 'Prevue Pet Products', 'All-natural cotton rope. Safe for birds. Bouncy boing toy for climbing and playing. Provides exercise and mental stimulation. Quick link connector for easy hanging.', 14.99, 13.49, '["https://img.chewy.com/is/image/catalog/54404_MAIN.jpg"]', '["bird", "toy", "rope", "climbing", "enrichment"]', 0, 1),
(85, 17, 'BIRD-ACC-004', 'Super Bird Creations Flying Trapeze Bird Toy', 'Super Bird Creations', 'Colorful acrylic beads. Includes bells. Safe vegetable-tanned leather. Stimulates natural play behavior. Suitable for small to medium-sized birds. Non-toxic materials.', 10.99, 9.89, '["https://img.chewy.com/is/image/catalog/54405_MAIN.jpg"]', '["bird", "toy", "acrylic", "bells", "colorful"]', 0, 1),
(86, 17, 'BIRD-ACC-005', 'Kaytee Clean & Cozy White Small Animal & Bird Bedding, 85L', 'Kaytee', 'Made from natural paper. 99% dust-free. Soft and absorbent. 6x more absorbent than wood shavings. Odor controlled. Compostable and biodegradable. Safe for birds and small animals.', 19.99, 17.99, '["https://img.chewy.com/is/image/catalog/54406_MAIN.jpg"]', '["bird", "bedding", "paper", "dust-free", "absorbent"]', 1, 1),
(87, 17, 'BIRD-ACC-006', 'Lixit Thumbs Up Bird Perch, 14 in', 'Lixit', 'Therapeutic perch promotes foot health. Variable diameter promotes healthy foot exercise. Helps prevent bumblefoot. Includes stainless steel bolt. Sandy texture helps keep nails trim.', 8.99, 8.09, '["https://img.chewy.com/is/image/catalog/54407_MAIN.jpg"]', '["bird", "perch", "foot-health", "therapeutic"]', 0, 1),
(88, 17, 'BIRD-ACC-007', 'Penn-Plax Bird Life Fruit Kabob Bird Toy', 'Penn-Plax', 'Colorful fruit-shaped toy. Non-toxic plastic. Promotes natural foraging behavior. Quick-link top for easy hanging. Bright colors attract birds. Suitable for parakeets, cockatiels and similar birds.', 6.99, 6.29, '["https://img.chewy.com/is/image/catalog/54408_MAIN.jpg"]', '["bird", "toy", "foraging", "colorful", "fruit"]', 0, 1),
(89, 16, 'BIRD-FOOD-007', 'Roudybush Daily Maintenance Bird Food, Mini, 44 oz', 'Roudybush', 'Cooked in-house for maximum nutrition retention. Formulated by avian nutritionists. No artificial colors or preservatives. Complete and balanced diet. For medium-sized parrots. Highly digestible.', 22.99, 20.68, '["https://img.chewy.com/is/image/catalog/54409_MAIN.jpg"]', '["bird", "bird-food", "pellets", "parrot", "daily-maintenance"]', 1, 1),
(90, 17, 'BIRD-ACC-008', 'Ware Manufacturing Plastic Scatterless Lock-N-Crock Pet Dish, 20 oz, Green', 'Ware', 'Lock-in place design prevents tipping and spilling. Easy to remove for cleaning. Dishwasher safe. Holds food and water. For cages with horizontal wire spacing.', 9.99, 8.99, '["https://img.chewy.com/is/image/catalog/54410_MAIN.jpg"]', '["bird", "feeder", "dish", "lock-in", "crock"]', 0, 1);


-- ============================================================
-- Small Pet Products (10) - category_id: 18=Small Pet Food, 19=Small Pet Accessories
-- ============================================================
INSERT INTO products (id, category_id, spu_code, name, brand, description, price, sale_price, images, tags, autoship_eligible, status) VALUES
(91, 18, 'SMPET-FOOD-001', 'Oxbow Animal Health Bunny Basics/T Adult Rabbit Food, 10 lbs', 'Oxbow', 'Timothy hay-based pellet for adult rabbits. Uniform pellets prevent selective feeding. Vitamins and minerals for complete nutrition. No artificial colors, flavors or preservatives. Vet recommended.', 19.99, 17.98, '["https://img.chewy.com/is/image/catalog/54411_MAIN.jpg"]', '["small-pet", "rabbit", "pellets", "timothy", "adult"]', 1, 1),
(92, 18, 'SMPET-FOOD-002', 'Kaytee Supreme Hamster & Gerbil Food, 3 lbs', 'Kaytee', 'Natural seeds, grains and pellets. Fortified with vitamins and minerals. No artificial colors or flavors. Supports energy and vitality. Natural foraging fun.', 7.99, 7.19, '["https://img.chewy.com/is/image/catalog/54412_MAIN.jpg"]', '["small-pet", "hamster", "gerbil", "food", "seeds"]', 1, 1),
(93, 18, 'SMPET-FOOD-003', 'Oxbow Animal Health Western Timothy Hay for Rabbits & Small Animals, 40 oz', 'Oxbow', '100% all-natural hand-selected Western Timothy Hay. Premium first-cut hay. Essential for healthy digestion. Supports dental health through natural chewing. No artificial ingredients.', 12.99, 11.69, '["https://img.chewy.com/is/image/catalog/54413_MAIN.jpg"]', '["small-pet", "rabbit", "guinea-pig", "hay", "timothy"]', 1, 1),
(94, 18, 'SMPET-FOOD-004', 'Supreme Petfoods Selective Naturals Guinea Pig Food, 3.3 lbs', 'Supreme Petfoods', 'High fiber recipe. Contains no added sugars. High quality vegetable protein. Vitamin C added for guinea pig health. Supports healthy digestion. Grain-free recipe.', 14.99, 13.48, '["https://img.chewy.com/is/image/catalog/54414_MAIN.jpg"]', '["small-pet", "guinea-pig", "vitamin-c", "high-fiber", "grain-free"]', 1, 1),
(95, 18, 'SMPET-FOOD-005', 'Zupreem Nature''s Promise Ferret Food, 4 lbs', 'ZuPreem', 'Chicken as first ingredient. High protein diet for ferrets. Complete and balanced nutrition. Omega-3 and omega-6 fatty acids. No artificial colors. Meets all nutritional requirements.', 16.99, 15.28, '["https://img.chewy.com/is/image/catalog/54415_MAIN.jpg"]', '["small-pet", "ferret", "high-protein", "chicken", "complete"]', 1, 1),
(96, 19, 'SMPET-ACC-001', 'Midwest Homes for Pets Wabbitat Deluxe Rabbit Home, 47 x 23.75 x 19.5 in', 'MidWest Homes for Pets', 'Extra-large living space. Easy to assemble folding design. Removable plastic bottom pan. 4 doorways for easy access. Includes a divider panel. Double doors for easy access.', 69.99, 62.98, '["https://img.chewy.com/is/image/catalog/54416_MAIN.jpg"]', '["small-pet", "rabbit", "cage", "habitat", "large"]', 0, 1),
(97, 19, 'SMPET-ACC-002', 'Kaytee My First Home Habitat for Hamsters & Gerbils, 30.5 x 18.5 in', 'Kaytee', 'Includes tubing, hideout, food dish and water bottle. Colorful habitat with multiple entrances. Deep base to hold bedding. Wire top for ventilation. Easy to clean design.', 49.99, 44.98, '["https://img.chewy.com/is/image/catalog/54417_MAIN.jpg"]', '["small-pet", "hamster", "gerbil", "cage", "habitat"]', 0, 1),
(98, 19, 'SMPET-ACC-003', 'Kaytee Clean & Cozy Natural Small Animal Bedding, 85L', 'Kaytee', 'Made from natural paper fiber. 99.9% dust-free. Soft and comfortable bedding. 6x more absorbent than wood shavings. Excellent odor control. Biodegradable and compostable.', 18.99, 17.08, '["https://img.chewy.com/is/image/catalog/54418_MAIN.jpg"]', '["small-pet", "bedding", "paper", "dust-free", "natural"]', 1, 1),
(99, 19, 'SMPET-ACC-004', 'Ware Manufacturing Chew-N-Treat Stick Combo Small Animal Treat, 5-count', 'Ware', 'All-natural wooden chew sticks. Apple flavored. Promotes dental health through natural chewing. Suitable for rabbits, chinchillas, guinea pigs and other small animals. No artificial flavors.', 4.99, 4.49, '["https://img.chewy.com/is/image/catalog/54419_MAIN.jpg"]', '["small-pet", "chew", "dental", "natural", "apple"]', 1, 1),
(100, 19, 'SMPET-ACC-005', 'Niteangel Wooden Activity Play Tunnel Toy for Hamster, Gerbil & Mice', 'Niteangel', 'All-natural wood construction. Chewable and safe. Provides hideout and exploration opportunities. Connects to other tubes. Promotes natural behavior. Suitable for hamsters, gerbils and mice.', 14.99, 13.48, '["https://img.chewy.com/is/image/catalog/54420_MAIN.jpg"]', '["small-pet", "hamster", "toy", "wood", "tunnel"]', 0, 1);


-- ============================================================
-- Product SKUs (~180 total)
-- ============================================================
INSERT INTO product_skus (product_id, sku_code, spec_name, price, sale_price, stock, weight_lbs, barcode, status) VALUES
-- Dog Food SKUs (products 1-12)
(1, 'DOG-FOOD-001-30LB', '30 lbs', 54.98, 49.48, 200, 30.00, '840243100011', 1),
(1, 'DOG-FOOD-001-15LB', '15 lbs', 29.98, 26.98, 300, 15.00, '840243100012', 1),
(1, 'DOG-FOOD-001-06LB', '6 lbs', 14.98, 13.48, 500, 6.00, '840243100013', 1),
(2, 'DOG-FOOD-002-30LB', '30 lbs', 64.98, 58.48, 150, 30.00, '840243100021', 1),
(2, 'DOG-FOOD-002-16LB', '16 lbs', 36.98, 33.28, 250, 16.00, '840243100022', 1),
(3, 'DOG-FOOD-003-35LB', '35 lbs', 72.99, 65.68, 120, 35.00, '840243100031', 1),
(3, 'DOG-FOOD-003-17LB', '17.5 lbs', 38.99, 35.08, 200, 17.50, '840243100032', 1),
(4, 'DOG-FOOD-004-30LB', '30 lbs', 68.99, 62.08, 100, 30.00, '840243100041', 1),
(4, 'DOG-FOOD-004-17LB', '17 lbs', 38.99, 35.08, 180, 17.00, '840243100042', 1),
(5, 'DOG-FOOD-005-25LB', '25 lbs', 89.99, 80.98, 80, 25.00, '840243100051', 1),
(5, 'DOG-FOOD-005-13LB', '13.2 lbs', 49.99, 44.98, 120, 13.20, '840243100052', 1),
(6, 'DOG-FOOD-006-26LB', '26 lbs', 74.95, 67.45, 100, 26.00, '840243100061', 1),
(6, 'DOG-FOOD-006-12LB', '12 lbs', 39.95, 35.95, 150, 12.00, '840243100062', 1),
(7, 'DOG-FOOD-007-28LB', '28 lbs', 57.99, 52.18, 150, 28.00, '840243100071', 1),
(7, 'DOG-FOOD-007-14LB', '14 lbs', 31.99, 28.78, 200, 14.00, '840243100072', 1),
(8, 'DOG-FOOD-008-25LB', '25 lbs', 62.98, 56.68, 120, 25.00, '840243100081', 1),
(8, 'DOG-FOOD-008-12LB', '12 lbs', 34.98, 31.48, 180, 12.00, '840243100082', 1),
(9, 'DOG-FOOD-009-40LB', '40 lbs', 44.98, 40.48, 200, 40.00, '840243100091', 1),
(9, 'DOG-FOOD-009-22LB', '22 lbs', 25.98, 23.38, 300, 22.00, '840243100092', 1),
(10, 'DOG-FOOD-010-27LB', '27 lbs', 79.99, 71.98, 80, 27.00, '840243100101', 1),
(10, 'DOG-FOOD-010-14LB', '14 lbs', 42.99, 38.68, 120, 14.00, '840243100102', 1),
(11, 'DOG-FOOD-011-24LB', '24 lbs', 59.98, 53.98, 100, 24.00, '840243100111', 1),
(11, 'DOG-FOOD-011-11LB', '11 lbs', 29.98, 26.98, 150, 11.00, '840243100112', 1),
(12, 'DOG-FOOD-012-34LB', '34 lbs', 78.98, 71.08, 80, 34.00, '840243100121', 1),
(12, 'DOG-FOOD-012-16LB', '16 lbs', 39.98, 35.98, 120, 16.00, '840243100122', 1),
-- Dog Treat SKUs (products 13-17)
(13, 'DOG-TREAT-001-24OZ', '24 oz', 8.99, 8.09, 500, 1.50, '840243100131', 1),
(14, 'DOG-TREAT-002-19OZ', '19 oz', 14.98, 13.48, 300, 1.20, '840243100141', 1),
(14, 'DOG-TREAT-002-09OZ', '9 oz', 8.98, 8.08, 400, 0.56, '840243100142', 1),
(15, 'DOG-TREAT-003-16OZ', '16 oz', 12.99, 11.69, 400, 1.00, '840243100151', 1),
(15, 'DOG-TREAT-003-06OZ', '6 oz', 6.49, 5.84, 600, 0.38, '840243100152', 1),
(16, 'DOG-TREAT-004-8OZ', '8 oz', 9.99, 8.99, 400, 0.50, '840243100161', 1),
(17, 'DOG-TREAT-005-6OZ', '6 oz', 8.99, 8.09, 500, 0.38, '840243100171', 1),
-- Dog Toy SKUs (products 18-22, 30)
(18, 'DOG-TOY-001-LG', 'Large', 13.99, 12.59, 300, 0.80, '840243100181', 1),
(18, 'DOG-TOY-001-MD', 'Medium', 11.99, 10.79, 300, 0.50, '840243100182', 1),
(18, 'DOG-TOY-001-SM', 'Small', 9.99, 8.99, 300, 0.25, '840243100183', 1),
(19, 'DOG-TOY-002-LG-2PK', 'Large 2-pack', 12.99, 11.69, 400, 0.60, '840243100191', 1),
(19, 'DOG-TOY-002-MD-2PK', 'Medium 2-pack', 10.99, 9.89, 400, 0.40, '840243100192', 1),
(20, 'DOG-TOY-003-LG', 'Large', 19.99, 17.99, 200, 1.20, '840243100201', 1),
(21, 'DOG-TOY-004-LG', 'Large', 10.99, 9.89, 300, 0.50, '840243100211', 1),
(22, 'DOG-TOY-005-26IN', '26 in', 9.99, 8.99, 400, 0.60, '840243100221', 1),
-- Dog Health SKUs (products 23-28)
(23, 'DOG-HEALTH-001-6DS', '6 doses (45-88 lbs)', 59.99, 53.99, 200, 0.20, '840243100231', 1),
(23, 'DOG-HEALTH-001-3DS', '3 doses (45-88 lbs)', 32.99, 29.68, 300, 0.10, '840243100232', 1),
(24, 'DOG-HEALTH-002-6DS', '6 doses (60.1-121 lbs)', 119.99, 107.98, 150, 0.15, '840243100241', 1),
(24, 'DOG-HEALTH-002-3DS', '3 doses (60.1-121 lbs)', 64.99, 58.48, 200, 0.08, '840243100242', 1),
(25, 'DOG-HEALTH-003-132CT', '132 chewable tablets', 34.98, 31.48, 300, 0.80, '840243100251', 1),
(26, 'DOG-HEALTH-004-30CT', '30 count', 29.98, 26.98, 400, 0.15, '840243100261', 1),
(27, 'DOG-HEALTH-005-MD', 'Medium', 39.95, 35.95, 200, 0.50, '840243100271', 1),
(27, 'DOG-HEALTH-005-SM', 'Small', 34.95, 31.45, 200, 0.40, '840243100272', 1),
(27, 'DOG-HEALTH-005-LG', 'Large', 44.95, 40.45, 150, 0.60, '840243100273', 1),
(28, 'DOG-HEALTH-006-16FT', '16 ft / up to 44 lbs', 19.99, 17.99, 300, 0.80, '840243100281', 1),
(29, 'DOG-FOOD-013-22LB', '22 lbs', 59.98, 53.98, 100, 22.00, '840243100291', 1),
(29, 'DOG-FOOD-013-11LB', '11 lbs', 32.98, 29.68, 150, 11.00, '840243100292', 1),
(30, 'DOG-TOY-006-LG', 'Large', 14.95, 13.45, 250, 0.60, '840243100301', 1),
(30, 'DOG-TOY-006-MD', 'Medium', 11.95, 10.75, 250, 0.40, '840243100302', 1);


INSERT INTO product_skus (product_id, sku_code, spec_name, price, sale_price, stock, weight_lbs, barcode, status) VALUES
-- Cat Food SKUs (products 31-42)
(31, 'CAT-FOOD-001-15LB', '15 lbs', 34.98, 31.48, 200, 15.00, '840243200011', 1),
(31, 'CAT-FOOD-001-06LB', '6 lbs', 16.98, 15.28, 300, 6.00, '840243200012', 1),
(32, 'CAT-FOOD-002-16LB', '16 lbs', 37.98, 34.18, 150, 16.00, '840243200021', 1),
(32, 'CAT-FOOD-002-06LB', '6 lbs', 17.98, 16.18, 250, 6.00, '840243200022', 1),
(33, 'CAT-FOOD-003-15LB', '15.5 lbs', 39.99, 35.99, 150, 15.50, '840243200031', 1),
(33, 'CAT-FOOD-003-07LB', '7 lbs', 19.99, 17.98, 200, 7.00, '840243200032', 1),
(34, 'CAT-FOOD-004-15LB', '15 lbs', 42.99, 38.68, 100, 15.00, '840243200041', 1),
(34, 'CAT-FOOD-004-07LB', '7.7 lbs', 23.99, 21.58, 150, 7.70, '840243200042', 1),
(35, 'CAT-FOOD-005-10LB', '10 lbs', 49.99, 44.98, 100, 10.00, '840243200051', 1),
(35, 'CAT-FOOD-005-04LB', '4 lbs', 22.99, 20.68, 150, 4.00, '840243200052', 1),
(36, 'CAT-FOOD-006-11LB', '11 lbs', 32.95, 29.65, 150, 11.00, '840243200061', 1),
(36, 'CAT-FOOD-006-05LB', '5 lbs', 17.95, 16.15, 200, 5.00, '840243200062', 1),
(37, 'CAT-FOOD-007-24CT', '24-count 3 oz cans', 21.98, 19.78, 300, 4.50, '840243200071', 1),
(37, 'CAT-FOOD-007-12CT', '12-count 3 oz cans', 11.98, 10.78, 400, 2.25, '840243200072', 1),
(38, 'CAT-FOOD-008-12CT', '12-count 12.5 oz cans', 29.88, 26.88, 200, 9.38, '840243200081', 1),
(39, 'CAT-FOOD-009-07LB', '7 lbs', 22.99, 20.68, 200, 7.00, '840243200091', 1),
(39, 'CAT-FOOD-009-03LB', '3.5 lbs', 12.99, 11.68, 300, 3.50, '840243200092', 1),
(40, 'CAT-FOOD-010-24CT', '24-count 5.5 oz cans', 34.80, 31.32, 200, 8.25, '840243200101', 1),
(41, 'CAT-FOOD-011-24CT', '24-count 3 oz cans', 22.80, 20.52, 300, 4.50, '840243200111', 1),
(42, 'CAT-FOOD-012-07LB', '7 lbs', 29.99, 26.98, 150, 7.00, '840243200121', 1),
(42, 'CAT-FOOD-012-03LB', '3.5 lbs', 16.99, 15.28, 200, 3.50, '840243200122', 1),
-- Cat Treat SKUs (products 43-45, 57)
(43, 'CAT-TREAT-001-30OZ', '30 oz', 12.98, 11.68, 400, 1.88, '840243200131', 1),
(43, 'CAT-TREAT-001-16OZ', '16 oz', 7.98, 7.18, 500, 1.00, '840243200132', 1),
(44, 'CAT-TREAT-002-50CT', '50 count', 19.99, 17.98, 300, 0.60, '840243200141', 1),
(45, 'CAT-TREAT-003-2OZ', '2 oz', 4.49, 4.04, 600, 0.13, '840243200151', 1),
(57, 'CAT-TREAT-004-5OZ', '5.5 oz', 8.99, 8.09, 500, 0.34, '840243200571', 1),
-- Cat Litter SKUs (products 46-50)
(46, 'CAT-LITTER-001-37LB', '37 lbs', 29.99, 26.98, 200, 37.00, '840243200161', 1),
(46, 'CAT-LITTER-001-18LB', '18.5 lbs', 16.99, 15.28, 300, 18.50, '840243200162', 1),
(47, 'CAT-LITTER-002-40LB', '40 lbs', 27.99, 25.19, 200, 40.00, '840243200171', 1),
(47, 'CAT-LITTER-002-20LB', '20 lbs', 15.99, 14.38, 300, 20.00, '840243200172', 1),
(48, 'CAT-LITTER-003-17LB', '17 lbs', 25.98, 23.38, 200, 17.00, '840243200181', 1),
(49, 'CAT-LITTER-004-28LB', '28 lbs', 33.99, 30.58, 150, 28.00, '840243200191', 1),
(49, 'CAT-LITTER-004-14LB', '14 lbs', 18.99, 17.08, 200, 14.00, '840243200192', 1),
(50, 'CAT-LITTER-005-28LB', '28 lbs', 24.98, 22.48, 200, 28.00, '840243200201', 1),
-- Cat Health/Accessories SKUs (products 51-56, 58-60)
(51, 'CAT-HEALTH-001-30DAY', '30-day starter kit', 29.99, 26.98, 300, 0.80, '840243200211', 1),
(52, 'CAT-HEALTH-002-6DS-SM', '6 doses (2.8-5.5 lbs)', 89.99, 80.98, 150, 0.10, '840243200221', 1),
(52, 'CAT-HEALTH-002-6DS-MD', '6 doses (5.6-11 lbs)', 89.99, 80.98, 150, 0.10, '840243200222', 1),
(53, 'CAT-HEALTH-003-60CT', '60 count', 7.99, 7.19, 400, 0.33, '840243200231', 1),
(54, 'CAT-HEALTH-004-STD', 'Standard 32-in', 29.99, 26.98, 200, 4.00, '840243200241', 1),
(55, 'CAT-HEALTH-005-72IN', '72 in, Gray', 79.99, 71.98, 80, 25.00, '840243200251', 1),
(56, 'CAT-HEALTH-006-STD', 'Standard', 14.99, 13.49, 300, 1.50, '840243200261', 1),
(58, 'CAT-FOOD-013-24CT', '24-count 1.3 oz trays', 19.99, 17.98, 300, 1.95, '840243200581', 1),
(59, 'CAT-HEALTH-007-STD', 'Standard', 11.99, 10.79, 400, 0.50, '840243200591', 1),
(60, 'CAT-HEALTH-008-3L', '3-Liter', 26.99, 24.28, 200, 2.20, '840243200601', 1);


INSERT INTO product_skus (product_id, sku_code, spec_name, price, sale_price, stock, weight_lbs, barcode, status) VALUES
-- Fish Food SKUs (products 61-65, 74)
(61, 'FISH-FOOD-001-1OZ', '1.59 oz', 9.99, 8.99, 400, 0.10, '840243300011', 1),
(61, 'FISH-FOOD-001-3OZ', '3.53 oz', 18.99, 17.08, 300, 0.22, '840243300012', 1),
(62, 'FISH-FOOD-002-7OZ', '7.06 oz', 8.99, 8.09, 500, 0.44, '840243300021', 1),
(62, 'FISH-FOOD-002-4OZ', '4.23 oz', 6.49, 5.84, 600, 0.26, '840243300022', 1),
(63, 'FISH-FOOD-003-2OZ', '2.01 oz', 6.99, 6.29, 500, 0.13, '840243300031', 1),
(64, 'FISH-FOOD-004-3OZ', '3.5 oz', 10.49, 9.44, 400, 0.22, '840243300041', 1),
(65, 'FISH-FOOD-005-0OZ', '0.5 oz', 5.99, 5.39, 600, 0.03, '840243300051', 1),
(74, 'FISH-FOOD-006-4OZ', '4.1 oz', 4.99, 4.49, 600, 0.26, '840243300741', 1),
-- Fish Tank & Accessories SKUs (products 66-73, 75)
(66, 'FISH-TANK-001-50G', 'Up to 50 Gallons', 49.99, 44.98, 200, 2.20, '840243300061', 1),
(67, 'FISH-TANK-002-70G', 'Up to 70 Gallons', 114.99, 103.48, 100, 8.60, '840243300071', 1),
(68, 'FISH-TANK-003-4LB', '4.4 lbs', 16.99, 15.28, 300, 4.40, '840243300081', 1),
(68, 'FISH-TANK-003-17LB', '17.6 lbs', 59.99, 53.98, 150, 17.60, '840243300082', 1),
(69, 'FISH-TANK-004-800T', '800-Test Kit', 34.99, 31.48, 300, 1.20, '840243300091', 1),
(70, 'FISH-TANK-005-500ML', '500 mL', 14.49, 13.04, 400, 1.10, '840243300101', 1),
(70, 'FISH-TANK-005-250ML', '250 mL', 8.49, 7.64, 500, 0.55, '840243300102', 1),
(71, 'FISH-TANK-006-6GAL', '6.8 Gallon Kit', 59.99, 53.99, 100, 15.00, '840243300111', 1),
(72, 'FISH-TANK-007-STD', 'Standard', 7.99, 7.19, 500, 0.20, '840243300121', 1),
(73, 'FISH-TANK-008-20LB', '20 lbs', 12.99, 11.69, 300, 20.00, '840243300131', 1),
(75, 'FISH-TANK-009-30G', 'Up to 30 Gallons', 27.99, 25.18, 250, 1.80, '840243300751', 1),
-- Bird Food SKUs (products 76-81, 89)
(76, 'BIRD-FOOD-001-2LB', '2 lbs', 5.99, 5.39, 500, 2.00, '840243400011', 1),
(76, 'BIRD-FOOD-001-5LB', '5 lbs', 13.99, 12.58, 300, 5.00, '840243400012', 1),
(77, 'BIRD-FOOD-002-2LB', '2.25 lbs', 12.99, 11.69, 300, 2.25, '840243400021', 1),
(77, 'BIRD-FOOD-002-4LB', '4 lbs', 22.99, 20.68, 200, 4.00, '840243400022', 1),
(78, 'BIRD-FOOD-003-1LB', '1 lb', 17.99, 16.18, 300, 1.00, '840243400031', 1),
(79, 'BIRD-FOOD-004-10OZ', '10 oz', 8.99, 8.09, 400, 0.63, '840243400041', 1),
(79, 'BIRD-FOOD-004-19OZ', '19 oz', 15.99, 14.38, 300, 1.19, '840243400042', 1),
(80, 'BIRD-FOOD-005-2LB', '2 lbs', 7.49, 6.74, 400, 2.00, '840243400051', 1),
(81, 'BIRD-FOOD-006-4LB', '4.5 lbs', 16.99, 15.28, 300, 4.50, '840243400061', 1),
(89, 'BIRD-FOOD-007-44OZ', '44 oz', 22.99, 20.68, 200, 2.75, '840243400891', 1),
-- Bird Accessories SKUs (products 82-88, 90)
(82, 'BIRD-ACC-001-STD', '37x24x52 in', 149.99, 134.98, 50, 40.00, '840243400081', 1),
(83, 'BIRD-ACC-002-STD', '30.3x18x54 in', 119.99, 107.98, 60, 30.00, '840243400091', 1),
(84, 'BIRD-ACC-003-STD', 'Standard', 14.99, 13.49, 400, 0.50, '840243400101', 1),
(85, 'BIRD-ACC-004-STD', 'Standard', 10.99, 9.89, 500, 0.20, '840243400111', 1),
(86, 'BIRD-ACC-005-85L', '85L', 19.99, 17.99, 300, 3.00, '840243400121', 1),
(87, 'BIRD-ACC-006-14IN', '14 in', 8.99, 8.09, 500, 0.40, '840243400131', 1),
(88, 'BIRD-ACC-007-STD', 'Standard', 6.99, 6.29, 600, 0.15, '840243400141', 1),
(90, 'BIRD-ACC-008-20OZ', '20 oz, Green', 9.99, 8.99, 500, 0.40, '840243400901', 1),
-- Small Pet Food SKUs (products 91-95)
(91, 'SMPET-FOOD-001-10LB', '10 lbs', 19.99, 17.98, 200, 10.00, '840243500011', 1),
(91, 'SMPET-FOOD-001-05LB', '5 lbs', 11.99, 10.78, 300, 5.00, '840243500012', 1),
(92, 'SMPET-FOOD-002-3LB', '3 lbs', 7.99, 7.19, 400, 3.00, '840243500021', 1),
(93, 'SMPET-FOOD-003-40OZ', '40 oz', 12.99, 11.69, 300, 2.50, '840243500031', 1),
(93, 'SMPET-FOOD-003-15OZ', '15 oz', 6.49, 5.84, 400, 0.94, '840243500032', 1),
(94, 'SMPET-FOOD-004-3LB', '3.3 lbs', 14.99, 13.48, 200, 3.30, '840243500041', 1),
(95, 'SMPET-FOOD-005-4LB', '4 lbs', 16.99, 15.28, 200, 4.00, '840243500051', 1),
-- Small Pet Accessories SKUs (products 96-100)
(96, 'SMPET-ACC-001-LG', 'Large 47x23.75x19.5 in', 69.99, 62.98, 100, 20.00, '840243500061', 1),
(97, 'SMPET-ACC-002-STD', 'Standard 30.5x18.5 in', 49.99, 44.98, 120, 12.00, '840243500071', 1),
(98, 'SMPET-ACC-003-85L', '85L', 18.99, 17.08, 300, 3.00, '840243500081', 1),
(98, 'SMPET-ACC-003-178L', '178L', 29.99, 26.98, 200, 6.00, '840243500082', 1),
(99, 'SMPET-ACC-004-5CT', '5 count', 4.99, 4.49, 600, 0.25, '840243500091', 1),
(100, 'SMPET-ACC-005-STD', 'Standard', 14.99, 13.48, 300, 0.80, '840243500101', 1);

