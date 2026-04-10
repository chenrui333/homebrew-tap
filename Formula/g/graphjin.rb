class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.16.2.tar.gz"
  sha256 "dcdc552e78ecb2f404502e6f629aea4d68c8351d8d03e07174dff91d33aeb7a4"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4696fe8f3ca37be14c901db312e0271d188169ab20dbc6c482d464cf717cc55a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c94cd7b8dfd8761b69c2e8d3e5d1690040f07af1f2a76fc103169d16bf813611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6d6fa70a057a34fff0870d012302bad38893e3caddbe18ab239e0d02788e25d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f502ab6640d958981280a5d576fda333540e0142b8f5956306253cc424b6c0ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb3a0e3d25c0ceae3ba26607ceea56ae585386892856949025b375cfb4359003"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
