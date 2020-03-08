class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/4.4.3.1/allegro-4.4.3.1.tar.gz"
  sha256 "5de8189ec051e1865f359654f86ec68e2a12a94edd00ad06d1106caa5ff27763"
  head "https://github.com/liballeg/allegro5.git"

  depends_on "cmake" => :build
  depends_on 'libvorbis' => :optional

  def install
    args = std_cmake_args + ["-DWANT_DOCS=OFF"]
    system "cmake", ".", *args
    system "make install"
  end

  test do
    (testpath/"allegro_test.cpp").write <<-EOS
    #include <assert.h>
    #include <allegro5/allegro5.h>
    int main(int n, char** c) {
      if (!al_init()) {
        return 1;
      }
      return 0;
    }
    EOS

    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lallegro", "-lallegro_main", "-o", "allegro_test", "allegro_test.cpp"
    system "./allegro_test"
  end
end
