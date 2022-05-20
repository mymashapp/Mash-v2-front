import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:mash_flutter/constants/app_colors.dart';
import 'package:mash_flutter/controllers/card_controller.dart';
import 'package:mash_flutter/models/card_model.dart';
import 'package:mash_flutter/utils/distance_calculation.dart';
import 'package:url_launcher/url_launcher.dart';

class EventCardWidget extends StatelessWidget {
  const EventCardWidget({
    Key? key,
    required this.cardModel,
  }) : super(key: key);

  final CardModel cardModel;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.black.withOpacity(0.8),
          Colors.transparent,
          Colors.transparent,
          Colors.transparent,
          Colors.transparent,
          Colors.black.withOpacity(0.8)
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(15),
    );

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              width: Get.width,
              height: Get.height,
              imageUrl: cardModel.cardType == CardType.own
                  ? 'https://backend.mymashapp.com/${cardModel.pictureUrl ?? ''}'
                  : cardModel.pictureUrl ?? '',
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  const Center(
                child: CircularProgressIndicator(
                  color: AppColor.orange,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            decoration: decoration,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColor.orange,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                    gradient: LinearGradient(
                      colors: [AppColor.orange, Colors.black.withOpacity(0.2)],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.send_outlined,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              cardModel.name ?? '',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                    color: Colors.black38,
                                    offset: Offset(2, 2),
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                            ),
                            Text(
                              cardModel.category ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                    color: Colors.black38,
                                    offset: Offset(2, 2),
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (cardModel.rating != 0)
                        cardModel.cardType == CardType.yelp ||
                                cardModel.cardType == CardType.own
                            ? _buildYelpStarRatting()
                            : RatingBar.builder(
                                initialRating: cardModel.rating!,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                ignoreGestures: true,
                                itemSize: 25,
                                unratedColor: AppColor.lightOrange,
                                itemPadding: EdgeInsets.zero,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: AppColor.orange,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                      const Spacer(),
                      if (cardModel.cardType == CardType.yelp)
                        SizedBox(
                          width: 100,
                          child: Image.asset(
                            "assets/images/yelp_logo.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (cardModel.cardType == CardType.airbnb)
                        CachedNetworkImage(
                          imageUrl:
                              'https://cdn.freebiesupply.com/logos/large/2x/airbnb-2-logo-png-transparent.png',
                          fit: BoxFit.cover,
                          height: 60,
                          width: 60,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.orange,
                            ),
                          ),
                        ),
                      if (cardModel.cardType == CardType.groupon)
                        Image.asset(
                          "assets/images/groupon_logo.png",
                          height: 60,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                      InkWell(
                        onTap: () {
                          final position =
                              Get.find<CardController>().currentPosition;

                          Get.dialog(Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            insetPadding: const EdgeInsets.all(16),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 5.0),
                                  Text(cardModel.id.toString()),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            cardModel.name ?? '',
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: AppColor.orange,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (cardModel.phoneNo != null)
                                          IconButton(
                                            onPressed: () {
                                              launch(
                                                  "tel:${cardModel.phoneNo!}");
                                            },
                                            icon: const Icon(Icons.call),
                                            color: AppColor.orange,
                                          ),
                                        if (cardModel.url != null &&
                                            cardModel.url!.isNotEmpty)
                                          IconButton(
                                            onPressed: () {
                                              launch(cardModel.url ?? '');
                                            },
                                            icon: const Icon(Icons.link),
                                            color: AppColor.orange,
                                          )
                                      ],
                                    ),
                                  ),
                                  _infoTiles(
                                    title: "# of swipes today",
                                    value: cardModel.swipeCount!.toString(),
                                    iconData: Icons.groups_outlined,
                                  ),
                                  _infoTiles(
                                    title: "Distance",
                                    value: distanceBetweenPoint(
                                      position.latitude,
                                      position.longitude,
                                      cardModel.latitude ?? 0,
                                      cardModel.longitude ?? 0,
                                    ),
                                    iconData: Icons.directions_outlined,
                                  ),
                                ],
                              ),
                            ),
                          ));
                        },
                        child: const Icon(
                          Icons.error,
                          size: 40,
                          color: AppColor.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTiles(
      {required String title, String value = "", required IconData iconData}) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: AppColor.orange,
            offset: Offset(2, 2),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: AppColor.orange,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: AppColor.orange,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildYelpStarRatting() {
    String image = "assets/images/yelp_star/5.png";

    int starRating = (10 * cardModel.rating!).round();

    switch (starRating) {
      case 0:
        image = "assets/images/yelp_star/0.png";
        break;
      case 10:
        image = "assets/images/yelp_star/1.png";
        break;
      case 15:
        image = "assets/images/yelp_star/1_5.png";
        break;
      case 20:
        image = "assets/images/yelp_star/2.png";
        break;
      case 25:
        image = "assets/images/yelp_star/2_5.png";
        break;
      case 30:
        image = "assets/images/yelp_star/3.png";
        break;
      case 35:
        image = "assets/images/yelp_star/3_5.png";
        break;
      case 40:
        image = "assets/images/yelp_star/4.png";
        break;
      case 45:
        image = "assets/images/yelp_star/4_5.png";
        break;
      case 50:
        image = "assets/images/yelp_star/5.png";
        break;
    }

    return Image.asset(
      image,
      height: 25,
    );
  }
}
