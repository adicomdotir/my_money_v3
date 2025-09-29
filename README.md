# My Money V3

- Begin with a version using Java in Android Native. 
- https://github.com/adicomdotir/My-Money/tree/version1
-
- Create a second version using Kotlin with MVP Pattern in Android Native. 
- https://github.com/adicomdotir/My-Money
-
- Version 2 was a simple flutter version. 
- https://github.com/adicomdotir/my-mobile-training/tree/master/lib/my_money_app
- 
- Now create Version 3 with flutter and Clean Architecture.

<table>
  <tr>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/1.png"  width="100%" height="100%"></td>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/2.png"  width="100%" height="100%"></td>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/3.png"  width="100%" height="100%"></td>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/4.png"  width="100%" height="100%"></td>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/9.png"  width="100%" height="100%"></td>
  </tr>
  <tr>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/5.png"  width="100%" height="100%"></td>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/6.png"  width="100%" height="100%"></td>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/7.png"  width="100%" height="100%"></td>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/8.png"  width="100%" height="100%"></td>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/4.png"  width="100%" height="100%"></td>
  </tr>
 </table>

## Category Icons

- Each category now has an `iconKey` stored alongside `id`, `parentId`, `title`, and `color`.
- Icons are selected from bundled assets under `assets/expense_categories/expense_categories/`.
- Add/Edit Category screen includes an icon picker with search and preview.
- Category dropdown renders icons next to names.
- Backward compatibility: existing data without `iconKey` defaults to `ic_other`; migration backfills it.

Developer notes:
- Add new icons by placing PNGs in the folder and adding their keys to `IconCatalog.allIconKeys`.
- Default icon key is `ic_other`.
