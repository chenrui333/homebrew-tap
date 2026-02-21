class Dumper < Formula
  desc "CLI utility for creating database backups"
  homepage "https://elkirrs.github.io/dumper/"
  url "https://github.com/elkirrs/dumper/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "c6c80041434b24a61448a609193d411930b2243cb9b1047481620fc7be9c6410"
  license "MIT"
  head "https://github.com/elkirrs/dumper.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dumper --version")
    cmd = "#{bin}/dumper -config ./notfound.yaml -all=true 2>&1"
    assert_match "configuration loading error", shell_output(cmd, 1)
  end
end
