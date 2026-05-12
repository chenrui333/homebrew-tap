class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "4a292fe2b456842be9ecf4d633bf81812cdef1f67bb8c16c355605dc76464b93"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef10293860edfbae93b62940dc248710a658f292183db39460a37458c17bb2b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff7b0a4d7d9935f7da717d6162d3a40d07fbc0a4ee04a13dd2a26686b9b7cf6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4577a3219b2080b1fb7b1c7b7c0a8665bff05474655133ed27a5a28166ae527"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dbb641cfd25a542c8d6a3aa0132791cde91aa2b34c518569d5a03303c7017bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83f9de3f383f9149ad0dc965b34fa1c662d34e8d2de91d699ab54605db08a370"
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
