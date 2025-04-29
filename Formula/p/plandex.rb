class Plandex < Formula
  desc "AI driven development in your terminal. Designed for large, real-world tasks"
  homepage "https://plandex.ai/"
  url "https://github.com/plandex-ai/plandex/archive/refs/tags/cli/v2.1.0.tar.gz"
  sha256 "8ab1cbd53ca1adc3fd6999a820bd81e51f19f0c832b37b8cc7215138c55d3c3d"
  license "MIT"
  head "https://github.com/plandex-ai/plandex.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dced8f72aac416da2c615afb7c74d634bfa14aef8aa1d90616b33c1d4336f35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04f8cfe803c69aa38a4aaef34c3abce590b16e25a29e16bb4a4e933f070c8daa"
    sha256 cellar: :any_skip_relocation, ventura:       "61d8334d5f7d49c61e962c069ef969f317af090b10d9bf92c775df203817e2fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfdf7f11b93132170a0b8fe251a8df1252901318dc77d5b4253204fab4431347"
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
