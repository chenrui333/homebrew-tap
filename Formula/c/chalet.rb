class Chalet < Formula
  desc "Containerize your dev environments"
  homepage "https://github.com/chalet-dev/chalet"
  url "https://github.com/chalet-dev/chalet/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "df98043f4258d9a55e6dd41f2e9a8a302cbc7740974ae77fe43926953bea223c"
  license "MIT"
  revision 1
  head "https://github.com/chalet-dev/chalet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1efe43cb8b080e8567de9945723ca26d5854f1bc9729c61f4c60bb0173a14f83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1efe43cb8b080e8567de9945723ca26d5854f1bc9729c61f4c60bb0173a14f83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1efe43cb8b080e8567de9945723ca26d5854f1bc9729c61f4c60bb0173a14f83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3007c72ebf982ded7e3f5b4ec0e8a8306026cd335561f5672ae19b2dd2a7a484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "579999f975d54a97732eaadb6967bfe395420875827c9a9858cba16e9506629d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    system bin/"chalet", "init"

    output = shell_output("#{bin}/chalet run")
    assert_match "Error opening YAML file", output
  end
end
