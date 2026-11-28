class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.27.2.tar.gz"
  sha256 "88918eeeab4c4cd2cd9849f96c4b63cb4da25a21671eadb717467eb656ccd80d"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "4f8e854781855726e3ff74e220f695edc4da905c76b0ac3de5169f55cbc92c4f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "463e95d1a8f34eab495c16ce7fc083d03328ac0afe0c7bdb54b935ec8fe9f28a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccc0f3d9d229488d806226b34675a87cc496d703231e4fa81ed217f1fdc1022b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "616f3e7951c1eda5b4320119f5f15c4c706f7af753a7027a103a413028cda6fc"
    sha256 cellar: :any,                 x86_64_linux:  "c05733a7e1bf1020461cad0294a666001ecb0f4a9e3d63233b262c36ddd3783e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "cmd" do
      system "go", "mod", "download"
    end
  end

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

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
