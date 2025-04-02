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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e01de3d04c42b5a452b972ac6b3057a6c3450e084120c6fd0950d496a8bcce84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b1a209dfddf1fa4ec47eeb36a0b4eacef0ac5b5afd1bcb42193c3289c1677b4"
    sha256 cellar: :any_skip_relocation, ventura:       "130fc19ced11d547fc0d59d329f370a34fa44f17536173eb790be94db5f0eb6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c992044bb73726fa4984ac177ee4d1a735ae3cfd8c0313481e51f6ad92eba3b4"
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
