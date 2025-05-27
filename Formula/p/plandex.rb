class Plandex < Formula
  desc "AI driven development in your terminal. Designed for large, real-world tasks"
  homepage "https://plandex.ai/"
  url "https://github.com/plandex-ai/plandex/archive/refs/tags/cli/v2.1.6.tar.gz"
  sha256 "32a6e59957935dfdfd118fd91c7ac57b0175a0334ac5d847e17cc29231b0f8cb"
  license "MIT"
  head "https://github.com/plandex-ai/plandex.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8d262bd21d3acda3e556a841afae11ca180a1c10b19b95f3c6e30d90332be09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03dedbcb851c9669171a53b253f36bbb9b11694903ca3b302d98bbd177b01658"
    sha256 cellar: :any_skip_relocation, ventura:       "11463a7da31c6488cfd006371fabf4bfdad41d2039995e24df1de64790ba9f01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e8471494a2e29cab3d3cbdfd62f7ec115a9683b13cdd4db4bfb31d5c68e951f"
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
