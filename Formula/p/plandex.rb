class Plandex < Formula
  desc "AI driven development in your terminal. Designed for large, real-world tasks"
  homepage "https://github.com/plandex-ai/plandex/"
  url "https://github.com/plandex-ai/plandex/archive/refs/tags/cli/v2.2.1.tar.gz"
  sha256 "04f80a0244e041e5366bd4947e9a83b29b67e25e9f9cf643d8811fe83a3190bc"
  license "MIT"
  head "https://github.com/plandex-ai/plandex.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "635a8e89828be94b695d2de647371b2af346cecc3c1417e9eaad94232732ea84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "635a8e89828be94b695d2de647371b2af346cecc3c1417e9eaad94232732ea84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "877ba05036bbc95698487569675715f81d9c906cbb92e50fe1b2d7f1aa9d8d48"
    sha256 cellar: :any,                 x86_64_linux:  "696ae2c8e35082f2805215a42985ba6e9384759be8430051fe05fe5c927a8ed1"
  end

  depends_on "go" => :build

  # plandex-shared loads this tiktoken-go encoding at startup (every command panics without it).
  resource "o200k_base.tiktoken" do
    url "https://openaipublic.blob.core.windows.net/encodings/o200k_base.tiktoken"
    sha256 "446a9538cb6c348e3516120d7c08b09f57c36495e2acfffe59a5bf8b0cfb1a2d"
  end

  deny_network_access!

  def fetch
    cd "app/cli" do
      system "go", "mod", "download"
    end
  end

  def install
    cd "app/cli" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X plandex-cli/version.Version=#{version}",
                                         output:  libexec/"plandex")
    end

    # tiktoken-go reads $TIKTOKEN_CACHE_DIR/<sha1 of the encoding URL> before downloading it
    tiktoken_cache = pkgshare/"tiktoken"
    encoding = resource("o200k_base.tiktoken")
    encoding.stage { tiktoken_cache.install "o200k_base.tiktoken" => Digest::SHA1.hexdigest(encoding.url) }
    (bin/"plandex").write_env_script libexec/"plandex", TIKTOKEN_CACHE_DIR: "${TIKTOKEN_CACHE_DIR:-#{tiktoken_cache}}"
    generate_completions_from_executable(bin/"plandex", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plandex version")

    # now it has annoying
    # # ? 👋 Hey there!
    # # It looks like this is your first time using Plandex on this computer.
    # # What would you like to do?
    # # > Start a trial on Plandex Cloud
    # #   Sign in, accept an invite, or create an account
    # system bin/"plandex"
  end
end
