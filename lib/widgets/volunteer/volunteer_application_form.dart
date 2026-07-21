import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/services/user_service.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/common/auth_prompt_dialog.dart';
import 'package:base42_events_mobile/widgets/common/custom_text_fields.dart';
import 'package:base42_events_mobile/utils.dart';
import 'package:base42_events_mobile/widgets/common/custom_button.dart';

class VolunteerApplicationForm extends StatefulWidget {
  final VoidCallback? onSubmit;

  const VolunteerApplicationForm({super.key, this.onSubmit});

  @override
  State<VolunteerApplicationForm> createState() =>
      _VolunteerApplicationFormState();
}

class _VolunteerApplicationFormState extends State<VolunteerApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  final _skillsController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _skillsController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final token = authProvider.token;
      final user = authProvider.currentUser;
      if (token == null || user == null) {
        if (!mounted) return;
        AuthPromptDialog.show(
          context,
          message: 'Sign in to submit your volunteer application',
        );
        return;
      }

      final name = (user.firstName.isNotEmpty || user.lastName.isNotEmpty)
          ? '${user.firstName} ${user.lastName}'.trim()
          : user.username;
      final email = user.email;

      final success = await UserService().submitVolunteerApplication(
        token,
        name: name,
        email: email,
        skills: _skillsController.text,
        message: _messageController.text,
      );

      if (!mounted) return;

      if (success) {
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
        _skillsController.clear();
        _messageController.clear();
        widget.onSubmit?.call();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong. Please try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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
          CustomButton.action(
            label: 'Submit Application',
            variant: ButtonVariant.solid,
            onTap: _isSubmitting ? null : _submitForm,
            isLoading: _isSubmitting,
          ),
        ],
      ),
    );
  }
}
