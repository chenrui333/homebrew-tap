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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33ffaa83f8f5271040291bb7249d7714ff61c1536fb4e4ce1f6a3da69232e1ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccebe8e4c20b92555deff0e29eb52c8c92a723ce0895d56160915c8345ca63c4"
    sha256 cellar: :any_skip_relocation, ventura:       "26fb909f1479027050bedd39e6c5ac61a5653939c22b4e656cb8b41a9d0bf165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89dcb288a789652ad2c3ea3530dd55cb0f04c11be418ad1c0fd924af3cd5711a"
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
