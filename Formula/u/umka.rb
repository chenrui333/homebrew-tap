class Umka < Formula
  desc "Statically typed embeddable scripting language"
  homepage "https://github.com/vtereshkov/umka-lang"
  url "https://github.com/vtereshkov/umka-lang/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "d5f4071f142ecb8859663e41654594b9d53fddfc0f60f9e9dd0fedda9f921b99"
  license "BSD-2-Clause"
  head "https://github.com/vtereshkov/umka-lang.git", branch: "master"

  def install
    system "make", "all"
    bin.install "build/umka"
    # include libraries
    lib.install "build/libumka.a"
    lib.install "build/#{shared_library("libumka")}"
    include.install Dir["build/include/*"]
  end

  test do
    (testpath/"hello.um").write <<~EOS
      fn main() {
        printf("Hello Umka!")
      }
    EOS

    assert_match "Hello Umka!", shell_output("#{bin}/umka #{testpath}/hello.um")
  end
end
