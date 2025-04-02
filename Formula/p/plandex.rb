class Plandex < Formula
  desc "AI driven development in your terminal. Designed for large, real-world tasks"
  homepage "https://plandex.ai/"
  url "https://github.com/plandex-ai/plandex/archive/refs/tags/cli/v2.0.5.tar.gz"
  sha256 "082079ea134be5b3d484346fde36e411817396898093c405c76a4f07ce5a1cce"
  license "MIT"
  head "https://github.com/plandex-ai/plandex.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a65fe017e482221be40e16d092f5f130f0bdb944be2a0f14a07b998e8c9a4aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08304a289711713672baf48e0845372ccd39eb0bdc5afe863448129123f24a54"
    sha256 cellar: :any_skip_relocation, ventura:       "45c0d8c75e05ef3c1d64a4aa860e1d05fe9a895edf04de68ab99d687103ed6f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ec3f352ad194a793b36c209ad81c582d9ec283a609d78ff9ddf0a9658499ace"
  end

  depends_on "go" => :build

  def install
    cd "app/cli" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X plandex-cli/version.Version=#{version}")
      generate_completions_from_executable(bin/"plandex", "completion")
    end
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
