class Zerolang < Formula
  desc "Programming language for agents with explicit effects and predictable memory"
  homepage "https://github.com/vercel-labs/zero"
  url "https://github.com/vercel-labs/zero/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "54538dc4e616327c5b0eefc8349a163b6887b9c2395a8dcc4e2149aad0029ebb"
  license :cannot_represent
  head "https://github.com/vercel-labs/zero.git", branch: "main"

  def install
    bin.mkpath
    cd "native/zero-c" do
      system ENV.cc, *Dir["src/*.c"], "-Iinclude",
             "-std=c11", "-Wall", "-Wextra", "-Wpedantic", "-Os",
             "-o", bin/"zero"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zero --version")

    (testpath/"hello.0").write <<~ZERO
      pub fun main(world: World) -> Void raises {
          check world.out.write("hello\\n")
      }
    ZERO
    system bin/"zero", "check", testpath/"hello.0"
  end
end
