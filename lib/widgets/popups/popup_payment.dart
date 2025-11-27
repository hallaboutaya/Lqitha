/// Payment popup dialog for unlocking contact information.
/// 
/// Displayed when user clicks "LQitha" or "LQitou" button on an item card.
/// Shows:
/// - Header explaining payment is needed to unlock contact
/// - Payment icon with decorative background shapes
/// - User name text indicating whose contact will be unlocked
/// - Price card showing "200 DA" payment amount
/// - Info box explaining why payment is required
/// - Cancel and "Pay 200 DA" buttons
/// - Security footer
/// 
/// After successful payment, automatically opens ContactUnlockedPopup.
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'popup_contact_unlocked.dart';

class PaymentPopup extends StatelessWidget {
  /// Name of the user whose contact will be unlocked
  final String userName;
  
  /// Title/description of the item being claimed
  final String itemTitle;

  const PaymentPopup({
    super.key,
    required this.userName,
    required this.itemTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: 355,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white.withOpacity(0.95),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1.27,
              color: Color(0xFFE5E5E5),
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 10,
              offset: Offset(0, 8),
              spreadRadius: -6,
            ),
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 25,
              offset: Offset(0, 20),
              spreadRadius: -5,
            )
          ],
        ),
        child: Stack(
          children: [
            // Close Button
            Positioned(
              right: 20,
              top: 20,
              child: IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.pop(context),
                color: const Color(0xFF2D2433).withOpacity(0.7),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(17.27),
              child: SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Unlock Contact Information',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryPurple,
                            fontSize: 18,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w700,
                            height: 1.56,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Pay to unlock contact details and collect your item',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w400,
                            height: 1.43,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Payment Icon
                  Center(
                    child: _buildPaymentIcon(),
                  ),
                  const SizedBox(height: 32),
                  // User Name Text
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'To unlock ',
                            style: TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 14,
                              fontFamily: 'Arimo',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                            ),
                          ),
                          TextSpan(
                            text: "$userName's",
                            style: const TextStyle(
                              color: AppColors.primaryPurple,
                              fontSize: 14,
                              fontFamily: 'Arimo',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                            ),
                          ),
                          const TextSpan(
                            text: ' contact and collect\n your item',
                            style: TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 14,
                              fontFamily: 'Arimo',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Price Card
                  _buildPriceCard(),
                  const SizedBox(height: 20),
                  // Info Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(13.26),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF9FAFB),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1.27,
                          color: Color(0xFFE5E7EB),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'This helps maintain our platform and rewards those who help reunite people with their belongings.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 12,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w400,
                        height: 1.62,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 44,
                            decoration: ShapeDecoration(
                              color: const Color(0x4CE5E5E5),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1.27,
                                  color: Color(0xFFE5E5E5),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: AppColors.textTertiary,
                                  fontSize: 14,
                                  fontFamily: 'Arimo',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (_) => ContactUnlockedPopup(userName: userName),
                            );
                          },
                          child: Container(
                            height: 44,
                            decoration: ShapeDecoration(
                              color: AppColors.primaryPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: AppColors.shadowBlack,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                  spreadRadius: -2,
                                ),
                                BoxShadow(
                                  color: AppColors.shadowBlack,
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                  spreadRadius: -1,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Pay 200 DA',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Arimo',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Security Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const ShapeDecoration(
                          color: AppColors.primaryPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(999)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Secure payment powered by LQitha',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 12,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const ShapeDecoration(
                          color: AppColors.primaryOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(999)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background decorative shapes
        Positioned(
          child: Transform.rotate(
            angle: 0.09,
            child: Opacity(
              opacity: 0.08,
              child: Container(
                width: 96.98,
                height: 96.98,
                decoration: ShapeDecoration(
                  color: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          child: Transform.rotate(
            angle: -0.07,
            child: Opacity(
              opacity: 0.08,
              child: Container(
                width: 79.38,
                height: 79.38,
                decoration: ShapeDecoration(
                  color: AppColors.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Main icon container
        Container(
          width: 72.02,
          height: 72.02,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1.27,
                color: Color(0xFFE5E5E5),
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            shadows: const [
              BoxShadow(
                color: AppColors.shadowBlack,
                blurRadius: 6,
                offset: Offset(0, 4),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: AppColors.shadowBlack,
                blurRadius: 15,
                offset: Offset(0, 10),
                spreadRadius: -3,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: ShapeDecoration(
                color: AppColors.primaryPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const ShapeDecoration(
                        color: AppColors.primaryOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(999)),
                        ),
                      ),
                    ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17.27),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1.27,
            color: Color(0xFFE5E5E5),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: AppColors.shadowBlack,
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: AppColors.shadowBlack,
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: -1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 16, color: AppColors.textTertiary),
              const SizedBox(width: 8),
              const Text(
                'Payment Required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '200',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryPurple,
                  fontSize: 48,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'DA',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.tagText.copyWith(
                    color: AppColors.primaryOrange,
                    fontSize: 24,
                    height: 1.33,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: 64,
            height: 4,
            decoration: ShapeDecoration(
              color: AppColors.textLight.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'One-time unlock fee',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
              height: 1.33,
            ),
          ),
        ],
      ),
    );
  }
}
