class Vatomic < Formula
  desc "vatomic is a header library of atomics operations, supporting mainstream architectures: ARMv7, ARMv8 (AArch32 and AArch64), RISC-V, and x86_64."
  homepage "https://github.com/open-s4c/vatomic"
  url "https://github.com/open-s4c/vatomic/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "c48bb8c2c4b86b7c4a6d14038cc08e57c11fb14211f5cbb165c74b0406c499a9"
  license "MIT"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <vsync/atomic.h>
      #include <stdio.h>

      vatomic32_t count;

      int main() {
          vatomic_inc(&count);
          printf("count: %u\\n", vatomic_read(&count));
          return 0;
      }
    EOS

    # Compila o programa
    system ENV.cc, "test.c", "-I#{include}", "-o", "test"

    # Roda e verifica a saída
    assert_match "count: 1", shell_output("./test")
  end
end
