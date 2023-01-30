import 'package:flutter/material.dart';
import 'package:flutter_maps/router/app_router.dart';

class StoreAndCachingWidget extends StatelessWidget {
  const StoreAndCachingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 30,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              Text(
                ' Current Location',
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(height: 10),
              Text(
                ' Current Locatijaksdhajkhdaskjldhaskjdhaskjldhanson',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Colors.black,
                    ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          goRouter.pushNamed('storesPage');
                        },
                        child: const Text('Caching'),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          goRouter.pushNamed('downloaderPage');
                        },
                        child: const Text('Caching Map and Downloading'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
