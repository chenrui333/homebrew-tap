class Apkeep < Formula
  desc "Command-line tool for downloading APK files from various sources"
  homepage "https://github.com/EFForg/apkeep"
  url "https://github.com/EFForg/apkeep/archive/refs/tags/0.18.0.tar.gz"
  sha256 "627f2382c3c849cbf872c512cf5f7293d31714b630afdf531ec8a9263bea207e"
  license "MIT"
  head "https://github.com/EFForg/apkeep.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ad02304c71f8eed1279e94d751080a1a0b12612c4a1ddb184413140f96d1767"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e3bdbfbc029ea41d6a653290c5a49c359e777ece21bab46ec9032d71504633b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76b43a5321abb3bfd3b877204593b819ae73bf75f925ee0088e49c20039d5029"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57f16471ffe1d4ff4c34c1b8abf9bb45cc46c4f5cd08b4c5240fb7a48b917ab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5770090144270b7e1b2530b2a139b94947c78a635e3f9342eaa48b501a8b657b"
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
