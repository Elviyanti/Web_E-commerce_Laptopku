<?php
// Enable error reporting for debugging - REMOVE/DISABLE FOR PRODUCTION
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

session_start();
if (!isset($_SESSION['id_user'])) {
    header('Location: login.php');
    exit();
}

// Attempt to include config.php
// The require statement itself can cause a fatal error if the file is not found
// or if config.php has a parse error or dies prematurely.
try {
    require 'C:\xampp\htdocs\Laptopku\config.php'; // Memasukkan file konfigurasi
} catch (Throwable $t) {
    // error_log("Failed to include or error within config.php: " . $t->getMessage());
    die("Kesalahan konfigurasi server. Silakan coba lagi nanti. (Error: CFG1)");
}


// Check if $conn was successfully initialized in config.php
if (!isset($conn) || !$conn instanceof PDO) {
    // error_log("Database connection object (\$conn) not established after including config.php.");
    die("Terjadi kesalahan koneksi ke database. Silakan coba lagi nanti atau hubungi administrator. (Error: DBINIT)");
}

$user = null;
$product = null;
$reviews = [];
$default_image = "img/pp.png"; // Define default profile picture path

try {
    $id_user = $_SESSION['id_user'];
    $sql = "SELECT username, email, telepon, alamat, image_path FROM users WHERE id_user = :id_user";
    $stmt_user = $conn->prepare($sql);
    $stmt_user->bindParam(':id_user', $id_user, PDO::PARAM_INT);
    $stmt_user->execute();
    $user = $stmt_user->fetch(PDO::FETCH_ASSOC);

    if (!$user) {
        // error_log("User with id_user " . $id_user . " not found in database despite being in session.");
        die("Data pengguna tidak ditemukan. Silakan coba login kembali. (Error: U001)");
    }
    $image_path = !empty($user['image_path']) ? $user['image_path'] : $default_image;

} catch (PDOException $e) {
    // error_log("PDOException fetching user data: " . $e->getMessage());
    die("Terjadi kesalahan saat mengambil data pengguna. Silakan coba lagi nanti. (Error: UDB1)");
} catch (Throwable $t) {
    // error_log("General error fetching user data: " . $t->getMessage());
    die("Terjadi kesalahan umum saat memproses data pengguna. Silakan coba lagi nanti. (Error: UGEN1)");
}

// Ambil ID produk dari URL
$id_produk_get = $_GET['id'] ?? null;

if ($id_produk_get === null) {
    die("ID produk tidak diberikan dalam URL.");
} else {
    $id_produk = (int)$id_produk_get; // Cast to integer for safety

    try {
        // Query untuk mendapatkan detail produk, TERMASUK KOLOM 'stock'
        $query_product = "SELECT id_product, merk, variety, price, processor, ram, vga, screen_size, storages, feature, image_path, stock FROM products WHERE id_product = :id_product";
        $stmt_product = $conn->prepare($query_product);
        $stmt_product->bindParam(':id_product', $id_produk, PDO::PARAM_INT);
        $stmt_product->execute();
        $product = $stmt_product->fetch(PDO::FETCH_ASSOC);

        if (!$product) {
            die("Produk dengan ID " . htmlspecialchars($id_produk) . " tidak ditemukan.");
        }
    } catch (PDOException $e) {
        // error_log("PDOException fetching product (ID: ".$id_produk.") data: " . $e->getMessage());
        die("Terjadi kesalahan saat mengambil detail produk. Silakan coba lagi nanti. (Error: PDB1)");
    } catch (Throwable $t) {
        // error_log("General error fetching product (ID: ".$id_produk.") data: " . $t->getMessage());
        die("Terjadi kesalahan umum saat memproses detail produk. Silakan coba lagi nanti. (Error: PGEN1)");
    }

    // If product is found, try to fetch reviews
    if ($product) {
        try {
            $reviewQuery = "
                SELECT
                    r.rating, r.review_date, r.review_text,
                    u.username, u.image_path AS user_image_path
                FROM Review r
                INNER JOIN users u ON r.id_user = u.id_user
                WHERE r.id_product = :id_product
                ORDER BY r.review_date DESC
            ";
            $stmt_reviews = $conn->prepare($reviewQuery);
            $stmt_reviews->bindParam(':id_product', $id_produk, PDO::PARAM_INT);
            $stmt_reviews->execute();
            $reviews = $stmt_reviews->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            // error_log("PDOException fetching reviews for product (ID: ".$id_produk."): " . $e->getMessage());
            // Don't die, just inform that reviews couldn't be loaded. $reviews will remain empty.
            // You could set a flag here to display a message in the HTML if needed.
            echo "<script>console.error('Tidak dapat memuat ulasan: Kesalahan database.');</script>";
        } catch (Throwable $t) {
            // error_log("General error fetching reviews for product (ID: ".$id_produk."): " . $t->getMessage());
            echo "<script>console.error('Tidak dapat memuat ulasan: Kesalahan umum.');</script>";
        }
    }
}

if (!$product) {
   die("Terjadi kesalahan kritis dalam memuat data produk. Halaman tidak dapat ditampilkan.");
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="footer.css">
    <link rel="stylesheet" href="detail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Crimson+Text&family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Playfair+Display:ital,wght@0,400..900;1,400..900&family=Russo+One&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <title>Detail - <?= htmlspecialchars($product['merk'] . ' ' . $product['variety']) ?> - Laptopku.</title>
    <style>
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.5); backdrop-filter: blur(5px); }
        .modal-content { background-color: #ffffff; margin: 10% auto; padding: 30px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.3); width: 60%; max-width: 500px; text-align: center; animation: modalFadeIn 0.4s ease-out; position: relative; }
        .close { color: #555; position: absolute; top: 10px; right: 15px; font-size: 20px; font-weight: bold; cursor: pointer; transition: color 0.2s ease-in; }
        .close:hover { color: #ff0000; }
        .modal-icon { margin-bottom: 20px; font-size: 50px; }
        .modal h2 { font-size: 24px; margin-bottom: 15px; color: #333; }
        .modal p { font-size: 16px; color: #666; margin-bottom: 20px; }
        .modal-button-green { background-color: #28a745; color: white; padding: 10px 20px; border: none; border-radius: 5px; font-size: 16px; font-weight: bold; cursor: pointer; transition: background-color 0.3s ease, transform 0.2s ease; }
        .modal-button-green:hover { background-color: #218838; transform: scale(1.05); }
        .modal-button-green:active { background-color: #1e7e34; transform: scale(0.95); }
        @keyframes modalFadeIn { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
        
        .disabled-button { background-color: #ccc !important; color: #666 !important; cursor: not-allowed !important; opacity: 0.7; }
        .quantity-btn:disabled { background-color: #eee !important; color: #aaa !important; cursor: not-allowed !important; }
        .stock-info { font-size: 0.9em; color: #555; margin-bottom: 15px; }
        .stock-info strong { color: #333; }
        .out-of-stock { color: red; font-weight: bold; }
    </style>
    <script>
        let quantity = 1;
        // Ensure $product is available and $product['stock'] is set. PHP should die if not.
        const availableStock = <?= (int)($product['stock'] ?? 0) ?>;

        function increaseQuantity() {
            const quantityElement = document.getElementById("quantity");
            if (availableStock <= 0) {
                showModal('Maaf, stok produk ini sudah habis.', 'Perhatian!');
                return;
            }
            if (quantity < availableStock) {
                quantity++;
                quantityElement.textContent = quantity;
            } else {
                showModal('Jumlah tidak bisa melebihi stok yang tersedia (' + availableStock + ').', 'Perhatian!');
            }
        }

        function decreaseQuantity() {
            const quantityElement = document.getElementById("quantity");
            if (quantity > 1) {
                quantity--;
                quantityElement.textContent = quantity;
            }
        }

        function addToCart(productId) {
            if (availableStock <= 0) {
                showModal('Maaf, stok produk ini sudah habis dan tidak bisa ditambahkan ke keranjang.', 'Perhatian!');
                return;
            }

            if (quantity > availableStock) {
                showModal('Jumlah yang ingin ditambahkan (' + quantity + ') melebihi stok yang tersedia (' + availableStock + '). Silakan kurangi jumlah.', 'Perhatian!');
                return;
            }

            fetch('add_to_cart.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ id_product: productId, quantity: quantity })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showModal(data.message || 'Produk berhasil ditambahkan ke keranjang!', 'Berhasil!');
                    // Optional: update stock on page or reload
                    // setTimeout(() => window.location.reload(), 1500); // Reload after 1.5s
                } else {
                    showModal('Gagal: ' + (data.message || 'Tidak dapat menambahkan ke keranjang.'), 'Gagal!');
                }
            })
            .catch((error) => {
                console.error('Error:', error);
                showModal('Terjadi kesalahan koneksi. Silakan coba lagi.', 'Kesalahan!');
            });
        }

        function showModal(message, title = 'Informasi') {
            const modal = document.getElementById('infoModal');
            const modalMessageElement = modal.querySelector('p');
            const modalTitleElement = modal.querySelector('h2');
            const modalIcon = modal.querySelector('.modal-icon i');

            modalTitleElement.textContent = title;
            if (title.toLowerCase().includes("berhasil")) {
                modalIcon.className = 'fas fa-check-circle';
                modalIcon.style.color = 'green';
            } else if (title.toLowerCase().includes("gagal") || title.toLowerCase().includes("kesalahan") || title.toLowerCase().includes("perhatian")) {
                modalIcon.className = 'fas fa-exclamation-triangle';
                modalIcon.style.color = 'orange';
            } else { // Info
                modalIcon.className = 'fas fa-info-circle';
                modalIcon.style.color = '#007BFF';
            }
            
            if (modalMessageElement) {
                 modalMessageElement.innerHTML = message; // Use innerHTML if message might contain simple HTML like <br>
            }
            modal.style.display = 'block';
        }

        function closeModal() {
            const modal = document.getElementById('infoModal');
            modal.style.display = 'none';
        }

        window.onclick = function(event) {
            const modal = document.getElementById('infoModal');
            if (event.target === modal) {
                closeModal();
            }
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            const addToCartButtons = document.querySelectorAll('.cart, .add-to-cart');
            const quantityButtons = document.querySelectorAll('.quantity-btn');
            const addToCartTextButton = document.querySelector('.add-to-cart');

            if (availableStock <= 0) {
                addToCartButtons.forEach(button => {
                    button.classList.add('disabled-button');
                    button.disabled = true;
                });
                quantityButtons.forEach(button => {
                    button.disabled = true;
                });
                if(addToCartTextButton) {
                    addToCartTextButton.textContent = 'Stok Habis';
                }
                const stockDisplaySpan = document.getElementById('stock-display');
                if (stockDisplaySpan) {
                    stockDisplaySpan.classList.add('out-of-stock');
                }
            }

            const stockDisplaySpan = document.getElementById('stock-display');
            if (stockDisplaySpan) {
                stockDisplaySpan.textContent = availableStock > 0 ? availableStock : 'Habis';
                if (availableStock <=0 && !stockDisplaySpan.classList.contains('out-of-stock')) {
                     stockDisplaySpan.classList.add('out-of-stock');
                }
            }
        });
    </script>
</head>
<body>
    <nav class="navbar">
        <div class="logo">LAPTOPKU.</div>
        <div class="nav-links">
            <a href="home-login.php">Home</a>
            <a href="product-login.php">Shopping</a>
            <a href="cart.php" class="cartimg"><img src="img/chart-icon.png" alt="Keranjang Belanja"></a>
            <a href="profile.php"><img src="<?php echo htmlspecialchars($image_path); ?>" alt="Profile Picture" style="width:25px; height:25px; border-radius:50%"></a>
            <a href="logout.php"><i class="fa fa-sign-out"></i> Keluar</a>
        </div>
    </nav>
    
    <a href="product-login.php">
    <button class="back" aria-label="Kembali ke halaman produk">
        <i class="fa fa-angle-left"></i>
    </button></a>

    <div class="card-detail">
        <div class="product-image">
            <img src="<?= htmlspecialchars($product['image_path']) ?>" alt="Gambar <?= htmlspecialchars($product['merk']) ?>">
        </div>
        <div class="product-info">
            <h1 class="product-title"><?= htmlspecialchars($product['merk'] . ' ' . $product['variety']) ?></h1>
            <div class="product-price">Rp.<?= number_format($product['price'], 0, ',', '.') ?></div>
            
            <div class="stock-info">
                Sisa Stok: <strong id="stock-display"><?= htmlspecialchars($product['stock'] > 0 ? $product['stock'] : 'Habis') ?></strong>
            </div>

            <ul class="specs-list">
                <li><?= htmlspecialchars($product['processor']) ?></li>
                <li>RAM <?= htmlspecialchars($product['ram']) ?></li>
                <li><?= htmlspecialchars($product['vga']) ?></li>
                <li>Layar <?= htmlspecialchars($product['screen_size']) ?> inch & Penyimpanan <?= htmlspecialchars($product['storages']) ?></li>
            </ul>
            <p class="product-description">
                <?= nl2br(htmlspecialchars($product['feature'])) ?>
            </p>
            <div class="quantity-control">
                <button class="quantity-btn" onclick="decreaseQuantity()" aria-label="Kurangi jumlah" <?php if ($product['stock'] <= 0) echo 'disabled'; ?>>-</button>
                <span id="quantity" aria-live="polite">1</span>
                <button class="quantity-btn" onclick="increaseQuantity()" aria-label="Tambah jumlah" <?php if ($product['stock'] <= 0) echo 'disabled'; ?>>+</button>
                <div class="btntocart">
                    <button class="cart <?php if ($product['stock'] <= 0) echo 'disabled-button'; ?>" 
                            onclick="addToCart(<?= $product['id_product'] ?>)" 
                            aria-label="Tambah ke keranjang ikon"
                            <?php if ($product['stock'] <= 0) echo 'disabled'; ?>>
                        <i class="fa fa-shopping-cart"></i>
                    </button>
                    <button class="add-to-cart <?php if ($product['stock'] <= 0) echo 'disabled-button'; ?>" 
                            onclick="addToCart(<?= $product['id_product'] ?>)" 
                            <?php if ($product['stock'] <= 0) echo 'disabled'; ?>>
                        <?php echo ($product['stock'] <= 0) ? 'Stok Habis' : 'Tambah ke keranjang'; ?>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="container-ulasan">
        <h2 class="title">Ulasan<span class="blue-text-title"> Produk</span></h2>
        <?php if (!empty($reviews)): ?>
            <?php foreach ($reviews as $review): ?>
            <div class="card-ulasan">
                <div class="img-pp">
                     <img src="<?= htmlspecialchars(!empty($review['user_image_path']) ? $review['user_image_path'] : $default_image) ?>" alt="Foto profil <?= htmlspecialchars($review['username']) ?>">
                </div>
                <div class="ulasan">
                    <div class="rating-stars">
                        <?php for ($i = 1; $i <= 5; $i++): ?>
                            <i class="fa fa-star<?= $i <= round($review['rating']) ? '' : '-o' ?>" style="color: <?= $i <= round($review['rating']) ? '#FFD700' : '#ccc' ?>;"></i>
                        <?php endfor; ?>
                        <span style="margin-left: 5px; font-weight:bold;"><?= htmlspecialchars(number_format((float)$review['rating'], 1)) ?></span>
                    </div>
                    <h2><?= htmlspecialchars($review['username']) ?></h2>
                    <p><?= nl2br(htmlspecialchars($review['review_text'])) ?></p>
                    <small><?= htmlspecialchars(date('d M Y, H:i', strtotime($review['review_date']))) ?></small>
                </div>
            </div>
            <?php endforeach; ?>
        <?php else: ?>
            <p style="text-align: center; color: #666;">Belum ada ulasan untuk produk ini.</p>
        <?php endif; ?>
    </div>

    <div id="infoModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">×</span>
            <div class="modal-icon">
                <i class="fas fa-check-circle" style="color: green;"></i> <!-- Default, JS will change -->
            </div>
            <h2>Berhasil!</h2> <!-- Default, JS will change -->
            <p></p> <!-- Message set by JS -->
            <button class="modal-button-green" onclick="closeModal()">OK</button>
        </div>
    </div>
</body>
</html>