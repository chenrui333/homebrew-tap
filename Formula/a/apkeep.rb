class Apkeep < Formula
  desc "Command-line tool for downloading APK files from various sources"
  homepage "https://github.com/EFForg/apkeep"
  url "https://github.com/EFForg/apkeep/archive/refs/tags/0.17.0.tar.gz"
  sha256 "f5fa0d8c02d5c078f69ec18e080463113c3794be8b94130f6a81f463c36bca0b"
  license "MIT"
  head "https://github.com/EFForg/apkeep.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbd98a43607b52c3e8f47854e1bd3c0fe04bcac711b13fdb98684a4491198fb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ef7df84f1fe13312cd1096abbcb04cdd5eecf2a94e07d7e4a24d12e994bc317"
    sha256 cellar: :any_skip_relocation, ventura:       "4419fc3890843867991226173e5493e2145d333b5bdddd6d93c3c9140ad73599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70e851ecd533938b55112588b15fa6841a998261903e524d0b1f4d35cc176166"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apkeep --version")

    # hello world apk, https://play.google.com/store/apps/details?id=dev.egl.com.holamundo&hl=en_US
    system bin/"apkeep", "--app", "dev.egl.com.holamundo", testpath
    assert_path_exists "dev.egl.com.holamundo.xapk"
  end
end
