class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.49.tar.gz"
  sha256 "ba8204e186470a086c7dfb11b3f32b7609f2fd333896e07c4ffc308a444548b9"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89ba08409c6798baafe9a85a20d6fd519d3ed2b11920afec908ad8a8875f72c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8afa28ead95f8ad1ceb49b7e39ed1751b23612b692f996e60eaf7ecc6a31b30b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56cccfbf9ad4edf2aca44ed35cc97eba48692b2bcec386373bd3b3a9bf22e80f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9c1090c9ed42b62a7b97c6f07799aefe575b94c581157a1de130ba5573e149f"
    sha256 cellar: :any,                 x86_64_linux:  "05d4c8bf6a7451e5c0fefb537a0088342e322555cf6b1f57a5cbc8ef768d86f6"
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
