class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.26.tar.gz"
  sha256 "78f9ca4de526baa92333bcc7ccdcc7be091ee93c999edcb24e8639ee3493ff23"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "bc4c6846f977e3f51b64038e6e015d1a6ab97f35274fd80696d259a1cb0c76ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ba0964502a3a081986d66edc254e08208e171ee23f5ce24686320d02dd86eec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f22df20bc1e790b063575134bc1bbbdd868bbdaeb7f06bc1e8d602d8a56cd284"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ec1501ecb64765253dea90875925cf00a72c40d2ea77895f2dc968f1841bf19"
    sha256 cellar: :any,                 x86_64_linux:  "fa1952ed7cb9b8c78f28380202d9bf753bc6154a3c2f4e596cbff5db4572faca"
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
