class PublicOllamaFinder < Formula
  desc "Discover and enumerate public Ollama LLM servers with detailed model data"
  homepage "https://github.com/zonay/public-ollama-finder"
  url "https://github.com/zonay/public-ollama-finder/archive/refs/tags/build-1.4.8.tar.gz"
  sha256 "47ad4656d0301ea6980030bb3e734ab56412f17b30e0150abf5501915e786b22"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5db7d0a4bd3a8126efd89faac4e154e4f443a788ba1ade514b08d6e0ecb87a45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81e5ed97cc688081c39a981df7259f7aa9f24d546233377631a9047590bb03de"
    sha256 cellar: :any_skip_relocation, ventura:       "9022ec627463ad6cf94fc96e622201eddc464093e5d38ac3fe66b3ba0aac0488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0268a56552883e85c536bfe86cbd4cd0a1811bf3fbcff40f13fa3c08d0fa9ca1"
  end

  deprecate! date: "2026-10-04", because: :repo_removed

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # No such device or address (os error 6)
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # Declining the legal prompt exits before any IP range is read or scanned.
    output = pipe_output(bin/"public-ollama-finder", "n\n", 0)
    assert_match "Access denied: Agreement required to proceed.", output
  end
end
