import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/header.dart';
import '../providers/user_provider.dart';

class PengaturanPage extends StatefulWidget {
  final Function(String)? onMenuSelected;

  const PengaturanPage({Key? key, this.onMenuSelected}) : super(key: key);

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  final TextEditingController _usernameBaruController = TextEditingController();
  final TextEditingController _passwordBaruController = TextEditingController();
  final TextEditingController _passwordLamaController = TextEditingController();

  @override
  void dispose() {
    _usernameBaruController.dispose();
    _passwordBaruController.dispose();
    _passwordLamaController.dispose();
    super.dispose();
  }

  void _ubahData(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final usernameBaru = _usernameBaruController.text.trim();
    final passwordBaru = _passwordBaruController.text.trim();
    final passwordLama = _passwordLamaController.text.trim();

    if (usernameBaru.isEmpty || passwordBaru.isEmpty || passwordLama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❗ Harap isi semua kolom.')),
      );
      return;
    }

    final hashedInputOld = userProvider.hashPassword(passwordLama);
    final hashedCurrent = userProvider.getHashedPassword();

    if (hashedInputOld != hashedCurrent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Password lama tidak cocok.')),
      );
      return;
    }

    userProvider.setPassword(passwordBaru);
    await userProvider.saveUserToFirebase(context);

    if (usernameBaru != userProvider.username) {
      await userProvider.updateUsername(context, usernameBaru);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Data berhasil diperbarui')),
    );

    _usernameBaruController.clear();
    _passwordBaruController.clear();
    _passwordLamaController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final usernameSaatIni = userProvider.username;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Pindahkan onMenuSelected ke dalam Header
          Header(
            title: 'Pengaturan Akun',
            onMenuSelected: widget.onMenuSelected,
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                const Icon(Icons.account_circle, size: 100, color: Colors.grey),
                const SizedBox(height: 24),
                SizedBox(
                  width: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Username Saat Ini"),
                      const SizedBox(height: 6),
                      TextField(
                        decoration: InputDecoration(
                          hintText: usernameSaatIni.isNotEmpty ? usernameSaatIni : 'Belum login',
                          border: const OutlineInputBorder(),
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 16),
                      const Text("Username Baru"),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _usernameBaruController,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan username baru',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text("Password Baru"),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _passwordBaruController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan password baru',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text("Password Lama"),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _passwordLamaController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan password lama',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => _ubahData(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Ubah Data"),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
