import 'package:flutter/material.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/common/custom_text_fields.dart';
import 'package:base42_events_mobile/utils.dart';

class VolunteerApplicationForm extends StatefulWidget {
  final VoidCallback? onSubmit;

  const VolunteerApplicationForm({super.key, this.onSubmit});

  @override
  State<VolunteerApplicationForm> createState() =>
      _VolunteerApplicationFormState();
}

class _VolunteerApplicationFormState extends State<VolunteerApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _skillsController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _skillsController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Application submitted! We\'ll be in touch soon.',
            style: context.textStyles.bodyMedium?.withColor(
              Theme.of(context).colorScheme.onInverseSurface,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _nameController.clear();
      _emailController.clear();
      _skillsController.clear();
      _messageController.clear();
      widget.onSubmit?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final onSurface = colorScheme.onSurface;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: _nameController,
            label: 'Full Name',
            validator: bookingRequiredFieldValidator,
          ),
          CustomTextField(
            controller: _emailController,
            label: 'Email Address',
            validator: bookingEmailValidator,
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
          ),
          CustomTextField(
            controller: _skillsController,
            label: 'Skills & Interests',
            validator: bookingRequiredFieldValidator,
            maxLines: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: TextFormField(
              controller: _messageController,
              validator: bookingRequiredFieldValidator,
              maxLines: 4,
              style: context.textStyles.bodyMedium?.withColor(onSurface),
              decoration: inputDecoration(context, 'Why do you want to volunteer?'),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isSubmitting ? null : _submitForm,
              child: _isSubmitting
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : const Text('Submit Application'),
            ),
          ),
        ],
      ),
    );
  }
}
