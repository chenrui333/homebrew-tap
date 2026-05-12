class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.12.3.tar.gz"
  sha256 "e926011a3163e0027578ff55f50ca4a4917337b1febec15f5e6a4dc71ee452cb"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a91ddb82112a39651d22474d42b9ea31003cba7ce99f9be3d99c7b710e848a05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30194727c69beb1818efcc98ee4cd33e81dc17c01f812e306c9e73ed4af122bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8beb1512e749b63c50b849845a458f255ec5829ac83083569d3ad4a09dffa15e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1de59b584e173f319b2344510e07c758f3ae33a44ec7bef0b6ef336f452d0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c097969d4cefcfdbfe476a5314fd8504d7489bb466174da7ade5571ba0f5b28b"
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
