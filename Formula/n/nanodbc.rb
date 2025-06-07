class Nanodbc < Formula
  desc "Small C++ wrapper for the native C ODBC API"
  homepage "https://nanodbc.github.io/nanodbc/"
  url "https://github.com/nanodbc/nanodbc/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "56228372042b689beccd96b0ac3476643ea85b3f57b3f23fb11ca4314e68b9a5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "3627ff1858f01199dd5e236230c4069c942ccc66a0462490824342af9dedc309"
    sha256 cellar: :any,                 arm64_sonoma:  "1d7862fbf0d36102f2e3b848ecd14c5e5458846f45a666b7d83ed9f54fbeff57"
    sha256 cellar: :any,                 ventura:       "3cc39fc8c85feb5d2f56e235d833a7b53f6f1b41020ff5618c8db7c4d61d33dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4faccb446d3585c91a3093817cca08f2b97c3b162237fad43f0fe2e0b1153377"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libiodbc"
  end

  on_linux do
    depends_on "unixodbc"
  end

  patch :DATA

  def install
    args = %w[
      -DNANODBC_DISABLE_TESTS=ON
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <nanodbc/nanodbc.h>
      int main() {
        nanodbc::string sql = NANODBC_TEXT("SELECT 1");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++14", "-o", "test", "-I#{include}", "-L#{lib}", "-lnanodbc"
    system "./test"
  end
end

__END__
diff --git a/nanodbc/nanodbc.cpp b/nanodbc/nanodbc.cpp
index fb85598..91ac6c2 100644
--- a/nanodbc/nanodbc.cpp
+++ b/nanodbc/nanodbc.cpp
@@ -260,9 +260,13 @@ constexpr std::size_t size(const T (&array)[N]) noexcept
 template <std::size_t N>
 inline std::size_t size(NANODBC_SQLCHAR const (&array)[N]) noexcept
 {
-    auto const n = std::char_traits<NANODBC_SQLCHAR>::length(array);
+    std::size_t n = 0;
+    while (n < N && array[n] != '\0')  // Manually calculate the length up to the null terminator
+    {
+        ++n;
+    }
     NANODBC_ASSERT(n < N);
-    return n < N ? n : N - 1;
+    return n;
 }

 template <class T>
@@ -3563,9 +3567,22 @@ std::list<datasource> list_datasources()
                 "incompatible SQLCHAR and string::value_type");

             datasource dsn;
-            dsn.name = string(&name[0], &name[std::char_traits<NANODBC_SQLCHAR>::length(name)]);
-            dsn.driver =
-                string(&driver[0], &driver[std::char_traits<NANODBC_SQLCHAR>::length(driver)]);
+
+            // Manual length calculation for 'name'
+            std::size_t name_len = 0;
+            while (name[name_len] != '\0')  // Calculate length manually
+            {
+                ++name_len;
+            }
+            dsn.name = string(&name[0], &name[name_len]);
+
+            // Manual length calculation for 'driver'
+            std::size_t driver_len = 0;
+            while (driver[driver_len] != '\0')  // Calculate length manually
+            {
+                ++driver_len;
+            }
+            dsn.driver = string(&driver[0], &driver[driver_len]);

             dsns.push_back(std::move(dsn));
             direction = SQL_FETCH_NEXT;
@@ -3616,7 +3633,14 @@ std::list<driver> list_drivers()
                 "incompatible SQLCHAR and string::value_type");

             driver drv;
-            drv.name = string(&descr[0], &descr[std::char_traits<NANODBC_SQLCHAR>::length(descr)]);
+            auto descr_len = 0;
+            while (descr[descr_len] != '\0')
+            {
+                ++descr_len;
+            }
+
+            drv.name = string(&descr[0], &descr[descr_len]);
+

             // Split "Key1=Value1\0Key2=Value2\0\0" into list of key-value pairs
             auto beg = &attrs[0];
