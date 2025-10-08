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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e0c78578dc468937c5f5326c33635f2c2d3dd54c79e6695f01f6aff91bb5aa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3dc32f9ce45117497f176618aab0eae95306abcb3ac2b5a35eeeba2e5d8433f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a4c95c52ace3520ba2c38e1eae74cb1ae0b8aad1c77d381b7f0838bf27d16cc"
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
