class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.12.1.tar.gz"
  sha256 "e4d37bd3e132d5ac35a3c84db5f2419a83cb5c020ce6cbd053707d4faad753bd"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b10ce90f84250ba670d156c78311ce61c0d9d9b37b98142f9c7df118c65b8bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69b1fa7a7f24bfdb65120ef8be8117a6ce665caa2de7afe2261230dccf89a7d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce584b446db3a761dcdc99f2450136fce44acf129d53a0946f0327e21b75938a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34589f5912d016c2111e5c800af4f5541df0da0c21dbe9b307f6f11efa0d6f4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dd6cb67f6d78bb83954bc91b2f4e41638fc831c4ebab604fb02e40f3ca71e3d"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purple --version 2>&1")
  end
end
