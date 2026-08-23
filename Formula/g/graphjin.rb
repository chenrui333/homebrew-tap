class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.41.tar.gz"
  sha256 "3dfd6a674f47e90a2f8f9de4f7c55106d687a18ee7a46a0dc13593426f2f66f3"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58d2974f3abaa50695ec67638258f788eb01ecc2fe056f9d2de40f622e1add8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c479b1d1b96d79c67f31662e65c846698784419ebdd4a740fe969cc5cc40824a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88182f3c19d0a6c3060833ef229020a8907efd3ec5f083c6029a17ce8f61bd93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1270183d1e7c61d771337e14cc44bea765639541f68f892dc27422df34b857de"
    sha256 cellar: :any,                 x86_64_linux:  "49bbd423cab81fb964951ce6ea7b149c3953a408bce434baa60984201b30fa1c"
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

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
