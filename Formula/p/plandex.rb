class Plandex < Formula
  desc "AI driven development in your terminal. Designed for large, real-world tasks"
  homepage "https://plandex.ai/"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af8cf992b4958c42afbb7975d7d0be544f938e73bb741a105e42c6bc419dc5c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af8cf992b4958c42afbb7975d7d0be544f938e73bb741a105e42c6bc419dc5c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af8cf992b4958c42afbb7975d7d0be544f938e73bb741a105e42c6bc419dc5c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d73e12b876c647cc9c5405a169b81daacbe3bd8fc0da62db560d41c64884d5a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d742bf6c0c1a0f93b9c1359ca2fdc0a3133e43aaf7c980fbdcb23a8d32d39ca"
  end

  depends_on "go" => :build

  def install
    cd "app/cli" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X plandex-cli/version.Version=#{version}")
      generate_completions_from_executable(bin/"plandex", shell_parameter_format: :cobra)
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
