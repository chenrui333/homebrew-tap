class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.14.3.tar.gz"
  sha256 "330a458983758783c1f26d132c0f33178b479b75f2fed5333bfd27935944fa29"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1bc7261c3543de4a7d82439292bdc5279fd2c891326954b8053fe462b1b4423"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40144711ef13284fd4c3fe13df7b076b0173cd58a00ccfd7f891a1e9e1f64bff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c385f3c1fe63ae65dfa194c18b37907bbfd4fea45332e25b14bb2c81c8e48ef6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a602ce9a10e7e2bd1b90637ed3b7a3b7d67ceb730da9e9c793ea83c4bf5dde28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b18be28b547756dd2703c247a7aab0d600e5aa4f1899ce392988675d82dbd91"
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
