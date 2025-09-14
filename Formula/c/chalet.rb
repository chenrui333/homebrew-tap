class Chalet < Formula
  desc "Containerize your dev environments"
  homepage "https://github.com/chalet-dev/chalet"
  url "https://github.com/chalet-dev/chalet/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "df98043f4258d9a55e6dd41f2e9a8a302cbc7740974ae77fe43926953bea223c"
  license "MIT"
  head "https://github.com/chalet-dev/chalet.git", branch: "main"

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
