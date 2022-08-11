import 'package:voola/global_env.dart';
import 'package:voola/shared.dart';

class NetworkSelectorScreen extends StatelessWidget {
  const NetworkSelectorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nets = NETWORKS_INFO.entries.toList();
    return CScaffold(
      appBar: CAppBar(
        elevation: 0,
        title: Text('Select network'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: nets.length,
          itemBuilder: (c, i) {
            var net = nets[i];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(context).pop(net.value);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.generalShapesBg,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(18),
                      child: net.value.icon(32),
                    ),
                    Text('${net.value.name}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
