# ELEC 481 FINAL EXAM CRIB SHEET
## Master Reference for Linear Systems Control Design

---

## 📌 CONTROLLABILITY & OBSERVABILITY

### Controllability Matrix
$$\mathcal{C}_x = [B \quad AB \quad A^2B \quad \cdots \quad A^{n-1}B]$$

**System is controllable if:** $\text{rank}(\mathcal{C}_x) = n$

### Observability Matrix
$$\mathcal{O}_x = \begin{bmatrix} C \\ CA \\ CA^2 \\ \vdots \\ CA^{n-1} \end{bmatrix}$$

**System is observable if:** $\text{rank}(\mathcal{O}_x) = n$

### ✅ Algorithm: Check Controllability/Observability
1. Form $\mathcal{C}_x$ or $\mathcal{O}_x$ matrix
2. Calculate rank (row reduction or determinant if square)
3. If rank = $n$ → system is controllable/observable
4. **Shortcut for 2×2:** Just check if $\det(\mathcal{C}_x) \neq 0$ or $\det(\mathcal{O}_x) \neq 0$

---

## 🎯 STATE FEEDBACK CONTROL (Chapter 14)

### Control Law
$$u = -Kx + K_r r$$

**Closed-loop system:** $\dot{x} = (A-BK)x + BK_r r$

**Goal:** Place closed-loop poles at desired locations $\{\lambda_1, \lambda_2, \ldots, \lambda_n\}$

### 🔑 Ackermann's Formula for K (State Feedback Gain)
$$K = [0 \quad 0 \quad \cdots \quad 0 \quad 1] \mathcal{C}_x^{-1} \Delta_c(A)$$

where:
- $\Delta_c(s) = s^n + \alpha_{n-1}s^{n-1} + \cdots + \alpha_1 s + \alpha_0$ (desired characteristic polynomial)
- $\Delta_c(A) = A^n + \alpha_{n-1}A^{n-1} + \cdots + \alpha_1 A + \alpha_0 I$

### ✅ Algorithm: Pole Placement Design
1. **Check controllability:** Verify $\text{rank}(\mathcal{C}_x) = n$
2. **Specify desired poles:** $\{\lambda_1, \lambda_2, \ldots, \lambda_n\}$
3. **Form desired char. poly.:** $\Delta_c(s) = (s-\lambda_1)(s-\lambda_2)\cdots(s-\lambda_n)$
4. **Compute controllability matrix:** $\mathcal{C}_x = [B \quad AB \quad \cdots \quad A^{n-1}B]$
5. **Compute $\Delta_c(A)$** using Cayley-Hamilton technique
6. **Apply Ackermann:** $K = [0 \;\cdots\; 0 \; 1]\mathcal{C}_x^{-1}\Delta_c(A)$
7. **Verify:** Check eigenvalues of $(A-BK)$ match desired poles

---

## 👁️ FULL-ORDER OBSERVER (Chapter 14)

### Observer Equation
$$\dot{\hat{x}} = A\hat{x} + Bu + G(y - C\hat{x})$$

**Simplified form:** $\dot{\hat{x}} = (A - GC)\hat{x} + Bu + Gy$

**Error dynamics:** $\dot{e} = (A-GC)e$ where $e = x - \hat{x}$

**Design goal:** Place observer poles 2-4× faster than controller poles

### 🔑 Ackermann's Formula for G (Observer Gain)
$$G = \Delta_e(A) \mathcal{O}_x^{-1} \begin{bmatrix} 0 \\ 0 \\ \vdots \\ 1 \end{bmatrix}$$

where $\Delta_e(s) = s^n + \beta_{n-1}s^{n-1} + \cdots + \beta_0$ (desired observer char. poly.)

### ✅ Algorithm: Full-Order Observer Design
1. **Check observability:** Verify $\text{rank}(\mathcal{O}_x) = n$
2. **Choose observer poles** 2-4× faster than controller poles
3. **Form desired char. poly.:** $\Delta_e(s) = (s-\mu_1)(s-\mu_2)\cdots(s-\mu_n)$
4. **Compute observability matrix:** $\mathcal{O}_x = [C; \; CA; \; CA^2; \; \cdots; \; CA^{n-1}]^T$
5. **Compute $\Delta_e(A)$** using Cayley-Hamilton
6. **Apply Ackermann:** $G = \Delta_e(A)\mathcal{O}_x^{-1}[0 \; \cdots \; 0 \; 1]^T$
7. **Combined observer:** $\dot{\hat{x}} = (A-BK-GC)\hat{x} + Gy + BK_r r$

**⚠️ CRITICAL:** $K$ formula has row vector on left, $G$ formula has column vector on right!

---

## 📉 REDUCED-ORDER OBSERVER

### When to Use
When some states are directly measured (e.g., $y = x_1$), only estimate unmeasured states

### Partition System
$$x = \begin{bmatrix} x_1 \\ x_2 \end{bmatrix}, \quad y = x_1 \text{ (measured)}$$

$$\begin{bmatrix} \dot{x}_1 \\ \dot{x}_2 \end{bmatrix} = \begin{bmatrix} A_{11} & A_{12} \\ A_{21} & A_{22} \end{bmatrix} \begin{bmatrix} x_1 \\ x_2 \end{bmatrix} + \begin{bmatrix} B_1 \\ B_2 \end{bmatrix} u$$

### Observer for $x_2$ only
**Define:** $z = \hat{x}_2 - G_e y$

**Dynamics:** $\dot{z} = (A_{22} - G_e A_{12})z + (A_{22} - G_e A_{12})G_e y + (B_2 - G_e B_1)u$

**Estimate:** $\hat{x}_2 = z + G_e y$

### ✅ Algorithm: Reduced-Order Observer
1. **Partition system** into measured ($x_1$) and unmeasured ($x_2$) states
2. **Choose observer poles** for $(n-q)$ dimensional estimator
3. **Use Ackermann** to find $G_e$ (dimension $(n-q) \times q$)
4. **Form observer equation** for $z = \hat{x}_2 - G_e y$
5. **Recover full state:** $\hat{x} = [y; \; \hat{x}_2]^T = [y; \; z + G_e y]^T$

---

## 🎯 TRACKING SYSTEM DESIGN (Chapter 15)

### Control Law
$$u = -Kx + K_r r$$

### For Zero Steady-State Error
$$K_r = -\frac{1}{C(A-BK)^{-1}B}$$

### ✅ Algorithm: Tracking Design
1. **Design $K$** for desired closed-loop poles (use Ackermann)
2. **Compute closed-loop matrix:** $(A-BK)$
3. **Invert:** $(A-BK)^{-1}$
4. **Calculate:** $K_r = -1/[C(A-BK)^{-1}B]$ (scalar for SISO)
5. **Verify steady-state:** For unit step, $y_{ss} = r_{ss} = 1$

**Check:** $\lim_{s \to 0} s Y(s) = 1$ for unit step tracking

---

## 📐 CANONICAL FORMS

### Controllable Canonical Form (CCF)
For transfer function: $G(s) = \frac{b_n s^n + \cdots + b_0}{s^n + a_{n-1}s^{n-1} + \cdots + a_0}$

$$A_c = \begin{bmatrix} 
0 & 1 & 0 & \cdots & 0 \\
0 & 0 & 1 & \cdots & 0 \\
\vdots & & \ddots & \ddots & \vdots \\
0 & 0 & 0 & \cdots & 1 \\
-a_0 & -a_1 & -a_2 & \cdots & -a_{n-1}
\end{bmatrix}, \quad 
B_c = \begin{bmatrix} 0 \\ 0 \\ \vdots \\ 0 \\ 1 \end{bmatrix}$$

$$C_c = [b_0 \; b_1 \; \cdots \; b_{n-1}], \quad D_c = b_n$$

### Observable Canonical Form (OCF)
$$A_o = \begin{bmatrix} 
0 & 0 & \cdots & 0 & -a_0 \\
1 & 0 & \cdots & 0 & -a_1 \\
0 & 1 & \cdots & 0 & -a_2 \\
\vdots & & \ddots & & \vdots \\
0 & 0 & \cdots & 1 & -a_{n-1}
\end{bmatrix}, \quad
C_o = [0 \; 0 \; \cdots \; 0 \; 1]$$

### Transformation Formulas
**To CCF:** $x = T_c x_c$ where $T_c = \mathcal{C}_x \mathcal{C}_{x_c}^{-1}$

**To OCF:** $x = T_o x_o$ where $T_o = \mathcal{O}_x^{-1} \mathcal{O}_{x_o}$

### ✅ Algorithm: Transform to CCF/OCF
1. **Find characteristic polynomial:** $\det(sI-A) = s^n + a_{n-1}s^{n-1} + \cdots + a_0$
2. **Form $A_c$ or $A_o$** using coefficients $\{a_i\}$
3. **Compute both controllability/observability matrices:** $\mathcal{C}_x$, $\mathcal{C}_{x_c}$ (or $\mathcal{O}_x$, $\mathcal{O}_{x_o}$)
4. **Find transformation:** $T_c = \mathcal{C}_x \mathcal{C}_{x_c}^{-1}$ (or $T_o = \mathcal{O}_x^{-1}\mathcal{O}_{x_o}$)
5. **Verify:** $A_c = T_c^{-1}AT_c$, $B_c = T_c^{-1}B$, $C_c = CT_c$

---

## 💎 JORDAN CANONICAL FORM (JCF)

### Distinct Eigenvalues
$$J = \text{diag}(\lambda_1, \lambda_2, \ldots, \lambda_n)$$

**Modal matrix:** $M = [v_1 \; v_2 \; \cdots \; v_n]$ (eigenvectors)

**Transform:** $A = MJM^{-1}$

### Repeated Eigenvalue (multiplicity $m$)
**Jordan block:**
$$J_i = \begin{bmatrix}
\lambda_i & 1 & 0 & \cdots & 0 \\
0 & \lambda_i & 1 & \cdots & 0 \\
 & & \ddots & \ddots & \vdots \\
0 & 0 & 0 & \cdots & 1 \\
0 & 0 & 0 & \cdots & \lambda_i
\end{bmatrix}_{m \times m}$$

### ✅ Algorithm: Jordan Form
1. **Find eigenvalues:** Solve $\det(sI-A) = 0$
2. **For each eigenvalue $\lambda_i$:**
   - Find nullity of $(\lambda_i I - A)$ = # of linearly independent eigenvectors
   - nullity = $n - \text{rank}(\lambda_i I - A)$
3. **If multiplicity > nullity:**
   - Need generalized eigenvectors
   - Solve $(\lambda_i I - A)^k x_k = 0$ but $(\lambda_i I - A)^{k-1}x_k \neq 0$
4. **Form modal matrix:** $M = [x_1 \; x_2 \; \cdots \; x_n]$
5. **Compute:** $J = M^{-1}AM$

### Controllability/Observability in JCF
**Controllable if:** Bottom element of each Jordan block's $B$ column $\neq 0$

**Observable if:** First element of each Jordan block's $C$ row $\neq 0$

---

## ⏱️ STATE TRANSITION MATRIX

### LTI System
$$\Phi(t, t_0) = e^{A(t-t_0)}$$

### Properties
1. $\Phi(t_0, t_0) = I$
2. $\frac{\partial \Phi}{\partial t} = A\Phi(t, t_0)$
3. $\Phi(t_2, t_0) = \Phi(t_2, t_1)\Phi(t_1, t_0)$ (transition property)
4. $\Phi^{-1}(t, t_0) = \Phi(t_0, t)$ (inversion property)

### Complete Solution
$$x(t) = \Phi(t, t_0)x(t_0) + \int_{t_0}^t \Phi(t, \tau)Bu(\tau) d\tau$$

### Method 1: Laplace Transform
$$e^{At} = \mathcal{L}^{-1}\{(sI - A)^{-1}\}$$

### Method 2: Cayley-Hamilton Technique (Preferred for Repeated Eigenvalues)

**For distinct eigenvalues:**
1. Find eigenvalues $\{\lambda_i\}$ of $A$
2. Express $e^{At} = \sum_{i=0}^{n-1} \alpha_i(t) A^i$
3. Solve system: $e^{\lambda_i t} = \sum_{j=0}^{n-1} \alpha_j(t) \lambda_i^j$ for all $i$
4. Once $\{\alpha_i(t)\}$ found, compute $e^{At}$

**For repeated eigenvalue $\lambda$ with multiplicity $m$:**
- Match derivatives: $\frac{d^k}{d\lambda^k}[e^{\lambda t}]\Big|_{\lambda=\lambda_i} = \frac{d^k}{d\lambda^k}\left[\sum_{j=0}^{n-1}\alpha_j(t)\lambda^j\right]\Big|_{\lambda=\lambda_i}$
- For $k = 0, 1, \ldots, m-1$

---

## 🧮 CAYLEY-HAMILTON TECHNIQUE

### Theorem
**Matrix $A$ satisfies its own characteristic polynomial:**

If $\det(sI-A) = s^n + a_{n-1}s^{n-1} + \cdots + a_0 = 0$

Then $A^n + a_{n-1}A^{n-1} + \cdots + a_1 A + a_0 I = 0$

### ✅ Algorithm: Compute $f(A)$ (e.g., $A^{101}$, $e^{At}$, etc.)
1. **Find eigenvalues** of $A$: $\{\lambda_i\}$
2. **Express:** $f(A) = \alpha_{n-1}A^{n-1} + \cdots + \alpha_1 A + \alpha_0 I$
3. **Match at eigenvalues:** $f(\lambda_i) = \alpha_{n-1}\lambda_i^{n-1} + \cdots + \alpha_0$ for all $i$
4. **For repeated eigenvalue** (multiplicity $m$):
   $$\frac{d^k f}{ds^k}\Big|_{s=\lambda_i} = \frac{d^k R}{ds^k}\Big|_{s=\lambda_i} \quad \text{for } k = 0, 1, \ldots, m-1$$
5. **Solve linear system** for $\{\alpha_i\}$ (you'll have $n$ equations, $n$ unknowns)
6. **Compute:** $f(A) = \sum_{i=0}^{n-1} \alpha_i A^i$

---

## 🔄 SEPARATION PRINCIPLE

### Key Concept
**Controller and observer designs are INDEPENDENT!**

**Closed-loop characteristic polynomial:**
$$\det(sI - A + BK) \cdot \det(sI - A + GC)$$

The $2n$ poles of the combined system are:
- $n$ controller poles (from $A - BK$)
- $n$ observer poles (from $A - GC$)

### ✅ Algorithm: Combined Controller-Observer Design
1. **Design $K$** for desired controller poles (Ackermann)
2. **Design $G$** for observer poles 2-4× faster (Ackermann)
3. **Combined observer equation:**
   $$\dot{\hat{x}} = (A - BK - GC)\hat{x} + Gy$$
4. **Control input:**
   $$u = -K\hat{x} + K_r r$$
5. **Closed-loop order:** $2n$ (plant + observer)

---

## ⚡ QUICK REFERENCE FORMULAS

### Transfer Function
$$H(s) = C(sI - A)^{-1}B + D$$

### Characteristic Polynomial
$$\det(sI - A) = 0$$

### Eigenvalue Relations
- $\text{tr}(A) = \sum_{i=1}^n \lambda_i$
- $\det(A) = \prod_{i=1}^n \lambda_i$

### 2×2 Matrix Inverse
$$\begin{bmatrix} a & b \\ c & d \end{bmatrix}^{-1} = \frac{1}{ad - bc} \begin{bmatrix} d & -b \\ -c & a \end{bmatrix}$$

### Pole Placement from Specifications
**Percent overshoot to damping ratio:**
$$\zeta = \frac{-\ln(\%OS/100)}{\sqrt{\pi^2 + \ln^2(\%OS/100)}}$$

**Settling time (2% criterion):**
$$\omega_n = \frac{4}{\zeta T_s}$$

**Complex poles:**
$$s = -\zeta \omega_n \pm j\omega_n\sqrt{1 - \zeta^2}$$

---

## 📝 EXAM PROBLEM PATTERNS

### Type 1: Controllability/Observability Check
**Given:** System matrices $A$, $B$, $C$
**Task:** Determine if system is controllable and/or observable
**Steps:**
1. Form $\mathcal{C}_x = [B \; AB \; A^2B \; \cdots]$ and/or $\mathcal{O}_x$
2. Check if $\text{rank}(\mathcal{C}_x) = n$ or $\text{rank}(\mathcal{O}_x) = n$
3. State conclusion clearly

### Type 2: State Feedback Design
**Given:** System $(A, B, C)$, desired closed-loop poles
**Task:** Design state feedback gain $K$
**Steps:**
1. Check controllability first!
2. Form $\Delta_c(s)$ from desired poles
3. Apply Ackermann formula for $K$
4. Verify: check eigenvalues of $(A-BK)$

### Type 3: Full-Order Observer Design
**Given:** System, observer pole specifications
**Task:** Design observer gain $G$
**Steps:**
1. Check observability first!
2. Choose observer poles 2-4× faster than plant
3. Form $\Delta_e(s)$
4. Apply Ackermann formula for $G$
5. Write complete observer equation

### Type 4: Tracking System Design
**Given:** System with reference input $r(t)$
**Task:** Achieve zero steady-state error
**Steps:**
1. Design $K$ for stability
2. Compute $(A-BK)^{-1}$
3. Calculate $K_r = -1/[C(A-BK)^{-1}B]$
4. Verify $y_{ss} = r_{ss}$ for step input

### Type 5: Transform to Canonical Form
**Given:** System $(A, B, C)$, request CCF or OCF
**Task:** Find transformation matrix and transformed system
**Steps:**
1. Find characteristic polynomial → extract $\{a_i\}$
2. Form $A_c$ or $A_o$ using standard structure
3. Compute transformation matrix $T$
4. Verify transformed matrices

### Type 6: State Transition Matrix
**Given:** Matrix $A$, find $e^{At}$
**Task:** Compute using Laplace or Cayley-Hamilton
**Steps:**
- **Option 1:** Laplace inverse of $(sI-A)^{-1}$
- **Option 2:** Cayley-Hamilton (faster for repeated eigenvalues)

### Type 7: Jordan Canonical Form
**Given:** Matrix $A$ with repeated eigenvalues
**Task:** Find Jordan form and modal matrix
**Steps:**
1. Find eigenvalues and their multiplicities
2. Check nullity vs. multiplicity
3. If nullity < multiplicity → find generalized eigenvectors
4. Form modal matrix $M$
5. Compute $J = M^{-1}AM$

---

## ⚠️ COMMON MISTAKES TO AVOID

1. **Confusing $K$ (state feedback) with $G$ (observer gain)**
   - $K$ is $p \times n$ (input × states)
   - $G$ is $n \times q$ (states × outputs)

2. **Observer pole placement**
   - Observer poles MUST be 2-4× faster than controller poles
   - Otherwise estimation error persists too long

3. **Ackermann formula confusion**
   - For $K$: $[0 \; \cdots \; 1] \mathcal{C}_x^{-1} \Delta_c(A)$ (row × matrix)
   - For $G$: $\Delta_e(A) \mathcal{O}_x^{-1} [0; \; \cdots; \; 1]$ (matrix × column)
   - **DIFFERENT FORMS!**

4. **Controllability check**
   - Must check rank of $[B \; AB \; \cdots \; A^{n-1}B]$
   - Not just $B$ alone!

5. **Tracking gain calculation**
   - Must invert $(A - BK)$, not just $A$
   - Don't forget the negative sign: $K_r = -1/[\cdots]$

6. **Closed-loop matrix**
   - It's $(A - BK)$, not $(A + BK)$
   - Negative sign matters!

7. **Cayley-Hamilton for repeated eigenvalues**
   - Must match derivatives up to multiplicity
   - Forgetting derivative conditions gives wrong $\alpha_i(t)$

8. **Jordan block structure**
   - 1's go ABOVE the diagonal
   - NOT below!

9. **Transformation verification**
   - $A' = T^{-1}AT$ (similarity transform)
   - NOT $TAT^{-1}$

10. **Observer initial conditions**
    - Can choose $\hat{x}(0)$ arbitrarily (usually zero)
    - Error $e(0) = x(0) - \hat{x}(0)$ decays based on observer poles

---

## ⏰ TIME-SAVING SHORTCUTS

### 2×2 Systems
**Controllability:** $\mathcal{C}_x = [B \; AB]$, check $\det(\mathcal{C}_x) \neq 0$

**Char. poly.:** $s^2 - \text{tr}(A) \cdot s + \det(A) = 0$

**Eigenvalues:** $\lambda = \frac{\text{tr}(A) \pm \sqrt{\text{tr}(A)^2 - 4\det(A)}}{2}$

**Stability (quick check):**
- If $\text{tr}(A) < 0$ AND $\det(A) > 0$ → stable

### Matrix Powers
Don't compute $A^{100}$ directly! Use Cayley-Hamilton:
1. Find eigenvalues
2. $A^{100} = \alpha_1 A + \alpha_0 I$
3. Solve: $\lambda_i^{100} = \alpha_1 \lambda_i + \alpha_0$

---

## 🎯 POLE-ZERO ASSIGNMENT (Chapter 15)

### Key Insight
**State feedback adds zeros without adding poles!**

### Standard Feedback System
$$G(s) = \frac{N(s)}{D(s)}$$

### With State Feedback
$$H_{eq}(s) = \frac{K(s)}{D(s)}$$
where $K(s)$ is numerator polynomial (degree < $n$)

### Closed-Loop Transfer Function
$$\frac{Y(s)}{R(s)} = \frac{A \cdot K(s)}{D(s) + A \cdot K(s)}$$

**Effect:** Zeros move root locus to the left → improved stability

---

## 📊 LEVERRIER'S ALGORITHM

**Purpose:** Find $\text{adj}(sI-A)$ and characteristic polynomial

**Steps:**
1. $P_n = I$
2. $a_{n-1} = \text{tr}(AP_n)$
3. $P_{n-1} = AP_n - a_{n-1}I$
4. **Repeat:** $a_{n-k} = \frac{1}{k}\text{tr}(AP_{n-k+1})$
   $$P_{n-k} = AP_{n-k+1} - a_{n-k}I$$
5. **Final check:** $AP_0 - a_0 I = 0$ (should be zero matrix)
6. $\text{adj}(sI-A) = P_n s^{n-1} + P_{n-1}s^{n-2} + \cdots + P_1$
7. Char. poly. $= s^n + a_{n-1}s^{n-1} + \cdots + a_0$

---

## ✅ CRITICAL EXAM CHECKLIST

**Before submitting your exam, verify:**

- [ ] Controllability checked before using Ackermann for $K$
- [ ] Observability checked before using Ackermann for $G$
- [ ] Closed-loop eigenvalues computed and match specifications
- [ ] Observer poles are 2-4× faster than controller poles
- [ ] $K_r$ computed correctly for tracking (includes negative sign!)
- [ ] Matrix dimensions match (K is $p \times n$, G is $n \times q$)
- [ ] Separation principle applied: $2n$ poles for combined system
- [ ] Transformation matrix verified: $A' = T^{-1}AT$
- [ ] All work shown for partial credit
- [ ] Final answers boxed or clearly indicated

---

## 🧪 STABILITY CHECKS

### Routh-Hurwitz Criterion
For polynomial $a_n s^n + \cdots + a_1 s + a_0 = 0$

**All roots in LHP ⟺ First column of Routh array all > 0**

### Direct Eigenvalue Check
All poles stable ⟺ $\text{Re}(\lambda_i) < 0$ for all $i = 1, \ldots, n$

---

## 🔊 IMPULSE RESPONSE
$$h(t) = \mathcal{L}^{-1}\{H(s)\} = \mathcal{L}^{-1}\{C(sI-A)^{-1}B + D\}$$

**For SISO systems:**
$$h(t) = Ce^{At}B + D\delta(t)$$

---

## 🌊 CONVOLUTION INTEGRAL
$$y(t) = \int_0^t h(t-\tau)u(\tau) d\tau + \text{(initial condition response)}$$

**Complete solution:**
$$y(t) = Ce^{At}x(0) + \int_0^t Ce^{A(t-\tau)}Bu(\tau)d\tau + Du(t)$$

---

## 🏁 FINAL EXAM STRATEGY

### Time Management (3-hour exam)
- **First 10 min:** Scan all problems, identify easiest ones
- **Next 60 min:** Solve controllability/observability checks, canonical forms
- **Next 90 min:** Tackle state feedback, observer, tracking problems
- **Last 20 min:** Review, verify calculations, box answers

### Partial Credit Strategy
1. **Always show setup** even if you can't finish
2. **Write formulas** you're using (Ackermann, etc.)
3. **State what you're checking** (controllability, etc.)
4. **Show matrix computations** step-by-step
5. **If stuck, write what you know** and move on

### Problem Priority
1. ✅ **High priority:** Controllability/observability checks (quick points)
2. ✅ **High priority:** State feedback design with Ackermann
3. ✅ **Medium priority:** Observer design
4. ⚠️ **Complex:** Tracking with $K_r$ calculation
5. ⚠️ **Time-intensive:** Jordan form with generalized eigenvectors

---

## 🚀 YOU'VE GOT THIS!

Remember:
- **Show ALL work** for maximum partial credit
- **Verify dimensions** of every matrix multiplication
- **Check eigenvalues** of closed-loop systems
- **Ackermann requires controllability/observability** - always check first!
- **Observer poles must be faster** than controller poles (2-4×)
- **State equations:** $\dot{x} = Ax + Bu$, Output: $y = Cx + Du$
- **LTI solution:** $x(t) = e^{At}x_0 + \int_0^t e^{A(t-\tau)}Bu(\tau)d\tau$

**You've prepared well. Trust your preparation. Good luck! 💪**
